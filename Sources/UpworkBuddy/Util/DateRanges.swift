import Foundation

struct DateRange: Sendable, Hashable {
    let start: Date
    let end: Date

    var startString: String { Self.iso.string(from: start) }
    var endString: String { Self.iso.string(from: end) }

    static let iso: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone.current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}

enum DateRanges {
    static func range(for period: Period, now: Date = Date(), calendar: Calendar = .current) -> DateRange {
        var cal = calendar
        cal.firstWeekday = 2 // Monday — Upwork weeks start Monday
        let start: Date
        switch period {
        case .today:
            start = cal.startOfDay(for: now)
        case .week:
            start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) ?? now
        case .month:
            start = cal.date(from: cal.dateComponents([.year, .month], from: now)) ?? now
        case .year:
            start = cal.date(from: cal.dateComponents([.year], from: now)) ?? now
        }
        return DateRange(start: start, end: now)
    }

    static func sparklineRange(days: Int, now: Date = Date(), calendar: Calendar = .current) -> DateRange {
        let end = calendar.startOfDay(for: now)
        let start = calendar.date(byAdding: .day, value: -(days - 1), to: end) ?? end
        return DateRange(start: start, end: now)
    }
}
