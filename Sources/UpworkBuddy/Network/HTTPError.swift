import Foundation

struct HTTPErrorBody: Sendable {
    let status: Int
    let body: String
    let retryAfter: TimeInterval?
}
