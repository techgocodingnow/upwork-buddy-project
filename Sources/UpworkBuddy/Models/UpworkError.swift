import Foundation

enum UpworkError: Error, LocalizedError, Sendable {
    case notAuthenticated
    case unauthorized
    case rateLimited(retryAfter: TimeInterval?)
    case missingClientId
    case oauthState(String)
    case http(status: Int, body: String)
    case graphqlErrors([String])
    case decoding(String)
    case noTenant
    case transport(String)

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:        return "Not signed in to Upwork."
        case .unauthorized:            return "Upwork session expired. Please sign in again."
        case .rateLimited(let retry):  return "Rate limited by Upwork. Retry in \(Int(retry ?? 60))s."
        case .missingClientId:         return "Missing UpworkClientId in Resources/Config.plist."
        case .oauthState(let msg):     return "OAuth callback failed: \(msg)"
        case .http(let status, _):     return "HTTP \(status) from Upwork."
        case .graphqlErrors(let xs):   return "Upwork GraphQL: \(xs.joined(separator: "; "))"
        case .decoding(let m):         return "Failed to decode Upwork response: \(m)"
        case .noTenant:                return "No Upwork organization (tenant) available."
        case .transport(let m):        return "Network error: \(m)"
        }
    }
}
