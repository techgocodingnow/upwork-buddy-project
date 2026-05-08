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

    /// Same-shape range one period earlier — used for delta-vs-prior comparisons.
    /// Today→yesterday, Week→last week, Month→last month, Year→last year.
    static func previousRange(for period: Period, now: Date = Date(), calendar: Calendar = .current) -> DateRange {
        var cal = calendar
        cal.firstWeekday = 2
        switch period {
        case .today:
            let startOfToday = cal.startOfDay(for: now)
            let startOfYesterday = cal.date(byAdding: .day, value: -1, to: startOfToday) ?? startOfToday
            let endOfYesterday = cal.date(byAdding: .second, value: -1, to: startOfToday) ?? startOfYesterday
            return DateRange(start: startOfYesterday, end: endOfYesterday)
        case .week:
            let thisWeekStart = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) ?? now
            let lastWeekStart = cal.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart) ?? thisWeekStart
            let lastWeekEnd = cal.date(byAdding: .second, value: -1, to: thisWeekStart) ?? thisWeekStart
            return DateRange(start: lastWeekStart, end: lastWeekEnd)
        case .month:
            let thisMonthStart = cal.date(from: cal.dateComponents([.year, .month], from: now)) ?? now
            let lastMonthStart = cal.date(byAdding: .month, value: -1, to: thisMonthStart) ?? thisMonthStart
            let lastMonthEnd = cal.date(byAdding: .second, value: -1, to: thisMonthStart) ?? thisMonthStart
            return DateRange(start: lastMonthStart, end: lastMonthEnd)
        case .year:
            let thisYearStart = cal.date(from: cal.dateComponents([.year], from: now)) ?? now
            let lastYearStart = cal.date(byAdding: .year, value: -1, to: thisYearStart) ?? thisYearStart
            let lastYearEnd = cal.date(byAdding: .second, value: -1, to: thisYearStart) ?? thisYearStart
            return DateRange(start: lastYearStart, end: lastYearEnd)
        }
    }
}
