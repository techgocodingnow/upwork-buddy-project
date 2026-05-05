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
    let breakdown: [DailyBreakdown]

    var id: Date { date }

    init(date: Date, earnings: Double, hours: Double, breakdown: [DailyBreakdown] = []) {
        self.date = date
        self.earnings = earnings
        self.hours = hours
        self.breakdown = breakdown
    }
}

struct DailyBreakdown: Hashable, Sendable, Identifiable {
    let label: String
    let earnings: Double
    let hours: Double

    var id: String { label }
}
