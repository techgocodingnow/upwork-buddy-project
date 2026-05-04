import Foundation

struct ProjectStat: Identifiable, Hashable, Sendable {
    let contractId: String
    let title: String
    let hours: Double
    let earnings: Double
    let hourlyRate: Double?

    var id: String { contractId }

    var derivedRate: Double {
        if let r = hourlyRate, r > 0 { return r }
        guard hours > 0 else { return 0 }
        return earnings / hours
    }
}
