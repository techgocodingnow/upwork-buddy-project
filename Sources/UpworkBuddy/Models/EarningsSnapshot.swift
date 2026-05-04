import Foundation

struct EarningsSnapshot: Hashable, Sendable {
    let totalHours: Double
    let totalEarnings: Double
    let projects: [ProjectStat]
    let generatedAt: Date

    static let empty = EarningsSnapshot(
        totalHours: 0,
        totalEarnings: 0,
        projects: [],
        generatedAt: .distantPast
    )
}

struct DailyPoint: Hashable, Sendable, Identifiable {
    let date: Date
    let earnings: Double
    let hours: Double

    var id: Date { date }
}
