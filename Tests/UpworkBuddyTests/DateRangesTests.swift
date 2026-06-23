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

    func testWeekRangeIsRollingSevenDays() {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        let wednesday = cal.date(from: DateComponents(year: 2026, month: 3, day: 11))!
        let range = DateRanges.range(for: .week, now: wednesday, calendar: cal)
        let dayCount = cal.dateComponents([.day], from: range.start, to: cal.startOfDay(for: wednesday)).day ?? 0
        XCTAssertEqual(dayCount, 6)
    }

    func testSparklineRangeSpansRequestedDays() {
        let now = Date()
        let range = DateRanges.sparklineRange(days: 7, now: now)
        let dayCount = Calendar.current.dateComponents([.day], from: range.start, to: Calendar.current.startOfDay(for: now)).day ?? 0
        XCTAssertEqual(dayCount, 6)
    }
}
