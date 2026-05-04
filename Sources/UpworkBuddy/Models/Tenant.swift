import Foundation

struct Tenant: Codable, Hashable, Identifiable, Sendable {
    let organizationId: String
    let title: String

    var id: String { organizationId }
}
