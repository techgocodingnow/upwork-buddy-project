import Foundation

enum Period: String, CaseIterable, Identifiable, Sendable {
    case today
    case week
    case month
    case year

    var id: String { rawValue }

    var label: String {
        switch self {
        case .today: return "Today"
        case .week:  return "Week"
        case .month: return "Month"
        case .year:  return "Year"
        }
    }

    var sparklineDays: Int {
        switch self {
        case .today, .week: return 7
        case .month:        return 30
        case .year:         return 90
        }
    }
}
