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
        switch period {
        case .today:
            return DateRange(start: calendar.startOfDay(for: now), end: now)
        case .week, .month, .year:
            return sparklineRange(days: period.sparklineDays, now: now, calendar: calendar)
        }
    }

    static func sparklineRange(days: Int, now: Date = Date(), calendar: Calendar = .current) -> DateRange {
        let end = calendar.startOfDay(for: now)
        let start = calendar.date(byAdding: .day, value: -(days - 1), to: end) ?? end
        return DateRange(start: start, end: now)
    }

    /// Same-shape range one period earlier — used for delta-vs-prior comparisons.
    /// Today→yesterday, Week→last week, Month→last month, Year→last year.
    static func previousRange(for period: Period, now: Date = Date(), calendar: Calendar = .current) -> DateRange {
        let cal = calendar
        switch period {
        case .today:
            let startOfToday = cal.startOfDay(for: now)
            let startOfYesterday = cal.date(byAdding: .day, value: -1, to: startOfToday) ?? startOfToday
            let endOfYesterday = cal.date(byAdding: .second, value: -1, to: startOfToday) ?? startOfYesterday
            return DateRange(start: startOfYesterday, end: endOfYesterday)
        case .week, .month, .year:
            let current = range(for: period, now: now, calendar: cal)
            let start = cal.date(byAdding: .day, value: -period.sparklineDays, to: current.start) ?? current.start
            let end = cal.date(byAdding: .second, value: -1, to: current.start) ?? current.start
            return DateRange(start: start, end: end)
        }
    }
}
