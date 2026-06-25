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
        case .week:
            return calendarWeekRange(now: now, calendar: calendar)
        case .month:
            return calendarRange(.month, now: now, calendar: calendar)
        case .year:
            return calendarRange(.year, now: now, calendar: calendar)
        }
    }

    static func sparklineRange(days: Int, now: Date = Date(), calendar: Calendar = .current) -> DateRange {
        let end = calendar.startOfDay(for: now)
        let start = calendar.date(byAdding: .day, value: -(days - 1), to: end) ?? end
        return DateRange(start: start, end: now)
    }

    static func fillDailyPoints(_ points: [DailyPoint], in range: DateRange, calendar: Calendar = .current) -> [DailyPoint] {
        var byDay: [Date: DailyPoint] = [:]
        for point in points {
            byDay[calendar.startOfDay(for: point.date)] = point
        }

        let endDay = calendar.startOfDay(for: range.end)
        var day = calendar.startOfDay(for: range.start)
        var filled: [DailyPoint] = []

        while day <= endDay {
            filled.append(byDay[day] ?? DailyPoint(date: day, earnings: 0, hours: 0))
            guard let next = calendar.date(byAdding: .day, value: 1, to: day), next > day else { break }
            day = next
        }

        return filled
    }

    static func fillMonthlyPoints(_ points: [DailyPoint], in range: DateRange, calendar: Calendar = .current) -> [DailyPoint] {
        var byMonth: [Date: DailyPoint] = [:]
        for point in points {
            let month = calendar.dateInterval(of: .month, for: point.date)?.start ?? calendar.startOfDay(for: point.date)
            let current = byMonth[month] ?? DailyPoint(date: month, earnings: 0, hours: 0)
            byMonth[month] = DailyPoint(
                date: month,
                earnings: current.earnings + point.earnings,
                hours: current.hours + point.hours,
                breakdown: mergedBreakdown(current.breakdown + point.breakdown)
            )
        }

        let endMonth = calendar.dateInterval(of: .month, for: range.end)?.start ?? calendar.startOfDay(for: range.end)
        var month = calendar.dateInterval(of: .month, for: range.start)?.start ?? calendar.startOfDay(for: range.start)
        var filled: [DailyPoint] = []

        while month <= endMonth {
            filled.append(byMonth[month] ?? DailyPoint(date: month, earnings: 0, hours: 0))
            guard let next = calendar.date(byAdding: .month, value: 1, to: month), next > month else { break }
            month = next
        }

        return filled
    }

    private static func mergedBreakdown(_ rows: [DailyBreakdown]) -> [DailyBreakdown] {
        var totals: [String: (earnings: Double, hours: Double)] = [:]
        for row in rows {
            let current = totals[row.label] ?? (earnings: 0, hours: 0)
            totals[row.label] = (earnings: current.earnings + row.earnings, hours: current.hours + row.hours)
        }
        return totals
            .map { DailyBreakdown(label: $0.key, earnings: $0.value.earnings, hours: $0.value.hours) }
            .sorted { $0.earnings == $1.earnings ? $0.label < $1.label : $0.earnings > $1.earnings }
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
        case .week:
            let current = range(for: period, now: now, calendar: cal)
            let start = cal.date(byAdding: .day, value: -period.sparklineDays, to: current.start) ?? current.start
            let end = cal.date(byAdding: .second, value: -1, to: current.start) ?? current.start
            return DateRange(start: start, end: end)
        case .month:
            return previousCalendarRange(.month, now: now, calendar: cal)
        case .year:
            return previousCalendarRange(.year, now: now, calendar: cal)
        }
    }

    private static func calendarWeekRange(now: Date, calendar: Calendar) -> DateRange {
        var cal = calendar
        cal.firstWeekday = 2
        cal.minimumDaysInFirstWeek = 1

        guard let interval = cal.dateInterval(of: .weekOfYear, for: now) else {
            return sparklineRange(days: Period.week.sparklineDays, now: now, calendar: cal)
        }

        let end = cal.date(byAdding: .second, value: -1, to: interval.end) ?? interval.end
        return DateRange(start: interval.start, end: end)
    }

    private static func calendarRange(_ component: Calendar.Component, now: Date, calendar: Calendar) -> DateRange {
        guard let interval = calendar.dateInterval(of: component, for: now) else {
            return DateRange(start: calendar.startOfDay(for: now), end: now)
        }
        let end = calendar.date(byAdding: .second, value: -1, to: interval.end) ?? interval.end
        return DateRange(start: interval.start, end: end)
    }

    private static func previousCalendarRange(_ component: Calendar.Component, now: Date, calendar: Calendar) -> DateRange {
        let current = calendarRange(component, now: now, calendar: calendar)
        let previousDate = calendar.date(byAdding: component, value: -1, to: current.start) ?? current.start
        return calendarRange(component, now: previousDate, calendar: calendar)
    }
}
