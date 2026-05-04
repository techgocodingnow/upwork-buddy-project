import XCTest
@testable import UpworkBuddy

final class DateRangesTests: XCTestCase {
    func testTodayRangeStartsAtMidnight() {
        let now = Date()
        let range = DateRanges.range(for: .today, now: now)
        let cal = Calendar.current
        XCTAssertEqual(cal.startOfDay(for: now), range.start)
        XCTAssertLessThanOrEqual(range.start, range.end)
    }

    func testWeekRangeIsMondayBased() {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        cal.firstWeekday = 2
        let wednesday = cal.date(from: DateComponents(year: 2026, month: 3, day: 11))!
        let range = DateRanges.range(for: .week, now: wednesday, calendar: cal)
        let comps = cal.dateComponents([.year, .month, .day, .weekday], from: range.start)
        XCTAssertEqual(comps.weekday, 2, "Week should start Monday")
    }

    func testSparklineRangeSpansRequestedDays() {
        let now = Date()
        let range = DateRanges.sparklineRange(days: 7, now: now)
        let dayCount = Calendar.current.dateComponents([.day], from: range.start, to: Calendar.current.startOfDay(for: now)).day ?? 0
        XCTAssertEqual(dayCount, 6)
    }
}
