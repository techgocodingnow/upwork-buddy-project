import Foundation

enum Period: String, CaseIterable, Identifiable, Sendable {
    case today
    case week
    case month
    case year

    var id: String { rawValue }

    /// Localized human label, e.g. "Today" or its translation. Caller can use
    /// the result directly inside `Text(...)`.
    var label: String {
        switch self {
        case .today: return L10n.t("Today")
        case .week:  return L10n.t("Week")
        case .month: return L10n.t("Month")
        case .year:  return L10n.t("Year")
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
