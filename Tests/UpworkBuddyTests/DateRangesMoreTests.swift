import Testing
import Foundation
@testable import UpworkBuddy

@Suite("DateRanges (extended)")
struct DateRangesMoreTests {

    private var posixCal: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.locale = Locale(identifier: "en_US_POSIX")
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }

    private func date(_ s: String) -> Date {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")!
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f.date(from: s)!
    }

    // MARK: - range(for:)

    @Test func todayRangeStartsAtMidnight() {
        let now = date("2026-05-12 15:30:00")
        let r = DateRanges.range(for: .today, now: now, calendar: posixCal)
        let midnight = posixCal.startOfDay(for: now)
        #expect(r.start == midnight)
        #expect(r.end == now)
    }

    @Test func weekRangeSpansMondayThroughSunday() {
        let now = date("2026-06-24 09:00:00")
        let r = DateRanges.range(for: .week, now: now, calendar: posixCal)
        let start = posixCal.dateComponents([.year, .month, .day], from: r.start)
        let end = posixCal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: r.end)
        #expect(start.year == 2026)
        #expect(start.month == 6)
        #expect(start.day == 22)
        #expect(end.year == 2026)
        #expect(end.month == 6)
        #expect(end.day == 28)
        #expect(end.hour == 23)
        #expect(end.minute == 59)
        #expect(end.second == 59)
    }

    @Test func monthRangeSpansCurrentMonth() {
        let now = date("2026-05-12 09:00:00")
        let r = DateRanges.range(for: .month, now: now, calendar: posixCal)
        let start = posixCal.dateComponents([.year, .month, .day], from: r.start)
        let end = posixCal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: r.end)
        #expect(start.year == 2026)
        #expect(start.month == 5)
        #expect(start.day == 1)
        #expect(end.year == 2026)
        #expect(end.month == 5)
        #expect(end.day == 31)
        #expect(end.hour == 23)
        #expect(end.minute == 59)
        #expect(end.second == 59)
    }

    @Test func yearRangeSpansCurrentYear() {
        let now = date("2026-05-12 09:00:00")
        let r = DateRanges.range(for: .year, now: now, calendar: posixCal)
        let start = posixCal.dateComponents([.year, .month, .day], from: r.start)
        let end = posixCal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: r.end)
        #expect(start.year == 2026)
        #expect(start.month == 1)
        #expect(start.day == 1)
        #expect(end.year == 2026)
        #expect(end.month == 12)
        #expect(end.day == 31)
        #expect(end.hour == 23)
        #expect(end.minute == 59)
        #expect(end.second == 59)
    }

    // MARK: - sparklineRange

    @Test func sparklineRangeSpansRequestedDays() {
        let now = date("2026-05-12 15:30:00")
        let r = DateRanges.sparklineRange(days: 7, now: now, calendar: posixCal)
        let comps = posixCal.dateComponents([.day], from: r.start, to: posixCal.startOfDay(for: now))
        #expect(comps.day == 6) // days-1 == 6
    }

    @Test func sparklineRangeAlignsStartToMidnight() {
        let now = date("2026-05-12 15:30:00")
        let r = DateRanges.sparklineRange(days: 30, now: now, calendar: posixCal)
        // start should be a midnight boundary
        let h = posixCal.component(.hour, from: r.start)
        let m = posixCal.component(.minute, from: r.start)
        #expect(h == 0 && m == 0)
    }

    @Test func fillDailyPointsPadsWeekThroughSunday() {
        let now = date("2026-06-24 09:00:00")
        let range = DateRanges.range(for: .week, now: now, calendar: posixCal)
        let points = DateRanges.fillDailyPoints([
            DailyPoint(date: date("2026-06-24 00:00:00"), earnings: 10, hours: 1)
        ], in: range, calendar: posixCal)

        let first = posixCal.dateComponents([.month, .day], from: points[0].date)
        let last = posixCal.dateComponents([.month, .day], from: points[6].date)
        #expect(points.count == 7)
        #expect(first.month == 6)
        #expect(first.day == 22)
        #expect(last.month == 6)
        #expect(last.day == 28)
        #expect(points[2].earnings == 10)
        #expect(points[6].earnings == 0)
    }

    // MARK: - previousRange

    @Test func previousTodayIsYesterday() {
        let now = date("2026-05-12 09:00:00")
        let r = DateRanges.previousRange(for: .today, now: now, calendar: posixCal)
        let comps = posixCal.dateComponents([.day], from: r.start)
        #expect(comps.day == 11)
        // end == 2026-05-11 23:59:59
        let endComps = posixCal.dateComponents([.day, .hour, .minute, .second], from: r.end)
        #expect(endComps.day == 11)
        #expect(endComps.hour == 23)
        #expect(endComps.minute == 59)
        #expect(endComps.second == 59)
    }

    @Test func previousMonthRangeIsPreviousCalendarMonth() {
        let now = date("2026-05-12 09:00:00")
        let r = DateRanges.previousRange(for: .month, now: now, calendar: posixCal)
        let start = posixCal.dateComponents([.year, .month, .day], from: r.start)
        let end = posixCal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: r.end)
        #expect(start.year == 2026)
        #expect(start.month == 4)
        #expect(start.day == 1)
        #expect(end.year == 2026)
        #expect(end.month == 4)
        #expect(end.day == 30)
        #expect(end.hour == 23)
        #expect(end.minute == 59)
        #expect(end.second == 59)
    }

    @Test func previousYearRangeIsPreviousCalendarYear() {
        let now = date("2026-05-12 09:00:00")
        let r = DateRanges.previousRange(for: .year, now: now, calendar: posixCal)
        let start = posixCal.dateComponents([.year, .month, .day], from: r.start)
        let end = posixCal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: r.end)
        #expect(start.year == 2025)
        #expect(start.month == 1)
        #expect(start.day == 1)
        #expect(end.year == 2025)
        #expect(end.month == 12)
        #expect(end.day == 31)
        #expect(end.hour == 23)
        #expect(end.minute == 59)
        #expect(end.second == 59)
    }

    @Test func previousWeekIsExactlyOneWeekEarlier() {
        let now = date("2026-05-12 09:00:00")
        let curr = DateRanges.range(for: .week, now: now, calendar: posixCal)
        let prev = DateRanges.previousRange(for: .week, now: now, calendar: posixCal)
        let diff = posixCal.dateComponents([.day], from: prev.start, to: curr.start)
        #expect(diff.day == 7)
    }

    // MARK: - iso formatter

    @Test func startEndStringsAreISODate() {
        let now = date("2026-05-12 09:00:00")
        let r = DateRanges.range(for: .today, now: now, calendar: posixCal)
        // YYYY-MM-DD, length 10
        #expect(r.startString.count == 10)
        #expect(r.endString.count == 10)
    }
}
