import Foundation

/// Sendable JSON value for GraphQL variables. Plain `Any` is not Sendable under Swift 6.
indirect enum JSONValue: Sendable, Encodable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case null
    case array([JSONValue])
    case object([String: JSONValue])

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .string(let v):  try c.encode(v)
        case .int(let v):     try c.encode(v)
        case .double(let v):  try c.encode(v)
        case .bool(let v):    try c.encode(v)
        case .null:           try c.encodeNil()
        case .array(let v):   try c.encode(v)
        case .object(let v):  try c.encode(v)
        }
    }
}

private struct GraphQLPayload: Encodable {
    let query: String
    let variables: [String: JSONValue]
}

/// Thin GraphQL client over URLSession with one-shot token refresh on 401 and
/// per-tenant header injection.
actor GraphQLClient {
    static let shared = GraphQLClient()

    private var tenantId: String?

    private func endpoint() throws -> URL { try AppConfig.url(.apiBaseURL) }

    func setTenantId(_ id: String?) {
        self.tenantId = id
    }

    func currentTenantId() -> String? { tenantId }

    struct Envelope<T: Decodable>: Decodable {
        let data: T?
        let errors: [GQLError]?
    }

    struct GQLError: Decodable {
        let message: String
    }

    /// Sends a query, decoding `data` into `T`. Refreshes once on HTTP 401 then retries.
    func execute<T: Decodable & Sendable>(
        query: String,
        variables: [String: JSONValue] = [:],
        as type: T.Type
    ) async throws -> T {
        try await execute(query: query, variables: variables, as: type, allowRetry: true)
    }

    private func execute<T: Decodable & Sendable>(
        query: String,
        variables: [String: JSONValue],
        as type: T.Type,
        allowRetry: Bool
    ) async throws -> T {
        let token = try await OAuthClient.shared.currentAccessToken()
        var request = URLRequest(url: try endpoint())
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let tenantId { request.setValue(tenantId, forHTTPHeaderField: "X-Upwork-API-TenantId") }

        request.httpBody = try JSONEncoder().encode(GraphQLPayload(query: query, variables: variables))

        let (data, resp): (Data, URLResponse)
        do {
            (data, resp) = try await URLSession.shared.data(for: request)
        } catch {
            throw UpworkError.transport(error.localizedDescription)
        }
        guard let http = resp as? HTTPURLResponse else {
            throw UpworkError.transport("Non-HTTP response")
        }

        if http.statusCode == 401 {
            guard allowRetry else { throw UpworkError.unauthorized }
            _ = try await OAuthClient.shared.refresh()
            return try await execute(query: query, variables: variables, as: type, allowRetry: false)
        }
        if http.statusCode == 429 {
            let retryAfter = (http.value(forHTTPHeaderField: "Retry-After")).flatMap(TimeInterval.init)
            throw UpworkError.rateLimited(retryAfter: retryAfter)
        }
        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw UpworkError.http(status: http.statusCode, body: body)
        }

        let envelope: Envelope<T>
        do {
            envelope = try JSONDecoder().decode(Envelope<T>.self, from: data)
        } catch {
            throw UpworkError.decoding(error.localizedDescription)
        }
        if let errors = envelope.errors, !errors.isEmpty {
            throw UpworkError.graphqlErrors(errors.map(\.message))
        }
        guard let payload = envelope.data else {
            throw UpworkError.decoding("Empty data field")
        }
        return payload
    }
}
