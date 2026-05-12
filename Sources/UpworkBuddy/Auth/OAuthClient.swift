import Foundation
import AppKit
import CryptoKit

/// OAuth 2.0 Authorization Code + PKCE for Upwork.
/// Endpoints per Upwork developer docs:
///   - authorize: https://www.upwork.com/ab/account-security/oauth2/authorize
///   - token:     https://www.upwork.com/api/v3/oauth2/token
actor OAuthClient {
    static let shared = OAuthClient()

    private var inFlightRefresh: Task<String, Error>?

    private func authorizeURL() throws -> URL { try AppConfig.url(.authorizeURL) }
    private func tokenURL() throws -> URL    { try AppConfig.url(.tokenURL) }
    private func redirectURI() throws -> String { try AppConfig.require(.redirectURI) }

    // MARK: - Public

    /// Returns a current access token, refreshing if expired. Throws `.notAuthenticated` if no refresh token.
    func currentAccessToken() async throws -> String {
        if let token = KeychainStore.read(.access),
           let expiry = KeychainStore.read(.expiresAt).flatMap(TimeInterval.init),
           Date().timeIntervalSince1970 < expiry {
            return token
        }
        return try await refresh()
    }

    /// Forces a refresh-token grant, dedup'd across concurrent callers.
    func refresh() async throws -> String {
        if let task = inFlightRefresh { return try await task.value }
        let task = Task<String, Error> { [weak self] in
            guard let self else { throw UpworkError.notAuthenticated }
            return try await self.performRefresh()
        }
        inFlightRefresh = task
        let result: Result<String, Error>
        do {
            let value = try await task.value
            result = .success(value)
        } catch {
            result = .failure(error)
        }
        inFlightRefresh = nil
        return try result.get()
    }

    private func performRefresh() async throws -> String {
        guard let refreshToken = KeychainStore.read(.refresh) else {
            throw UpworkError.notAuthenticated
        }
        let creds = try Self.clientCredentials()
        var body = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": creds.id
        ]
        if let secret = creds.secret { body["client_secret"] = secret }
        let response = try await postForm(to: try tokenURL(), body: body)
        try persistTokens(response)
        return response.accessToken
    }

    /// Builds the authorize URL with PKCE + state, persists transient values, and opens the browser.
    func startAuthorization() async throws {
        let creds = try Self.clientCredentials()
        let verifier = Self.randomBase64URL(bytes: 32)
        let challenge = Self.codeChallenge(for: verifier)
        let state = Self.randomBase64URL(bytes: 16)

        try KeychainStore.save(verifier, for: .codeVerifier)
        try KeychainStore.save(state, for: .oauthState)

        var components = URLComponents(url: try authorizeURL(), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: creds.id),
            URLQueryItem(name: "redirect_uri", value: try redirectURI()),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "code_challenge", value: challenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            // Force re-consent so newly enabled API key permissions get
            // baked into the access token. Without this, Upwork hands back
            // tokens carrying the previously approved scope set.
            URLQueryItem(name: "prompt", value: "consent")
        ]
        guard let url = components.url else { throw UpworkError.transport("Bad authorize URL") }

        // Boot the loopback listener BEFORE opening the browser so the redirect
        // never races against listener startup. RFC 8252 §7.3 loopback flow.
        try await MainActor.run {
            do {
                try OAuthCallbackBridge.shared.startListening()
            } catch {
                throw UpworkError.transport("Could not bind loopback OAuth listener on port \(OAuthCallbackBridge.port.rawValue): \(error.localizedDescription)")
            }
        }
        _ = await MainActor.run { NSWorkspace.shared.open(url) }
    }

    /// Handles the redirect URL fired into the app via the upworkbuddy:// scheme.
    func handleCallback(url: URL) async throws {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let items = components.queryItems else {
            throw UpworkError.oauthState("Malformed callback URL")
        }
        if let err = items.first(where: { $0.name == "error" })?.value {
            throw UpworkError.oauthState("Upwork returned error: \(err)")
        }
        guard let code = items.first(where: { $0.name == "code" })?.value,
              let returnedState = items.first(where: { $0.name == "state" })?.value else {
            throw UpworkError.oauthState("Missing code or state")
        }
        guard let storedState = KeychainStore.read(.oauthState), storedState == returnedState else {
            throw UpworkError.oauthState("State mismatch")
        }
        guard let verifier = KeychainStore.read(.codeVerifier) else {
            throw UpworkError.oauthState("Missing code_verifier")
        }
        try await exchange(code: code, verifier: verifier)
        KeychainStore.delete(.codeVerifier)
        KeychainStore.delete(.oauthState)
    }

    func logout() {
        KeychainStore.wipeAll()
    }

    // MARK: - Private

    private func exchange(code: String, verifier: String) async throws {
        let creds = try Self.clientCredentials()
        var body = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": try redirectURI(),
            "code_verifier": verifier,
            "client_id": creds.id
        ]
        if let secret = creds.secret { body["client_secret"] = secret }
        let response = try await postForm(to: try tokenURL(), body: body)
        try persistTokens(response)
    }

    private struct TokenResponse: Decodable {
        let accessToken: String
        let refreshToken: String?
        let expiresIn: Int

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
            case expiresIn = "expires_in"
        }
    }

    private func postForm(to url: URL, body: [String: String]) async throws -> TokenResponse {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = Self.formEncode(body).data(using: .utf8)

        let (data, resp): (Data, URLResponse)
        do {
            (data, resp) = try await URLSession.shared.data(for: request)
        } catch {
            throw UpworkError.transport(error.localizedDescription)
        }
        guard let http = resp as? HTTPURLResponse else {
            throw UpworkError.transport("Non-HTTP response")
        }
        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            Log.auth.error("Token endpoint HTTP \(http.statusCode): \(body, privacy: .private)")
            if http.statusCode == 401 || http.statusCode == 400 { throw UpworkError.unauthorized }
            throw UpworkError.http(status: http.statusCode, body: body)
        }
        do {
            return try JSONDecoder().decode(TokenResponse.self, from: data)
        } catch {
            throw UpworkError.decoding(error.localizedDescription)
        }
    }

    private func persistTokens(_ response: TokenResponse) throws {
        try KeychainStore.save(response.accessToken, for: .access)
        if let refresh = response.refreshToken {
            try KeychainStore.save(refresh, for: .refresh)
        }
        let expiresAt = Date().timeIntervalSince1970 + Double(max(0, response.expiresIn - 60))
        try KeychainStore.save(String(expiresAt), for: .expiresAt)
    }

    // MARK: - Static helpers

    struct ClientCredentials {
        let id: String
        let secret: String?
    }

    static func clientCredentials() throws -> ClientCredentials {
        guard let id = AppConfig.string(.clientId) else { throw UpworkError.missingClientId }
        return ClientCredentials(id: id, secret: AppConfig.string(.clientSecret))
    }

    /// Charset for `application/x-www-form-urlencoded` per WHATWG URL §5. Allows
    /// RFC 3986 unreserved chars only — every other byte gets percent-encoded.
    /// Critically, `&`, `=`, `+`, `:` must all be escaped inside values or they
    /// merge into adjacent params on the server side.
    private static let formUnreserved: CharacterSet = {
        var c = CharacterSet.alphanumerics
        c.insert(charactersIn: "-._~")
        return c
    }()

    static func formEncode(_ params: [String: String]) -> String {
        params
            .map { key, value in
                let encKey = key.addingPercentEncoding(withAllowedCharacters: formUnreserved) ?? key
                let encVal = value.addingPercentEncoding(withAllowedCharacters: formUnreserved) ?? value
                return "\(encKey)=\(encVal)"
            }
            .joined(separator: "&")
    }

    static func randomBase64URL(bytes count: Int) -> String {
        var data = Data(count: count)
        _ = data.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, count, $0.baseAddress!) }
        return base64URL(data)
    }

    static func codeChallenge(for verifier: String) -> String {
        let hash = SHA256.hash(data: Data(verifier.utf8))
        return base64URL(Data(hash))
    }

    static func base64URL(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
