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
        let wednesday = cal.date(from: DateComponents(year: 2026, month: 3, day: 11))!
        let range = DateRanges.range(for: .week, now: wednesday, calendar: cal)
        let start = cal.dateComponents([.year, .month, .day], from: range.start)
        let end = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: range.end)
        XCTAssertEqual(start.year, 2026)
        XCTAssertEqual(start.month, 3)
        XCTAssertEqual(start.day, 9)
        XCTAssertEqual(end.day, 15)
        XCTAssertEqual(end.hour, 23)
        XCTAssertEqual(end.minute, 59)
        XCTAssertEqual(end.second, 59)
    }

    func testSparklineRangeSpansRequestedDays() {
        let now = Date()
        let range = DateRanges.sparklineRange(days: 7, now: now)
        let dayCount = Calendar.current.dateComponents([.day], from: range.start, to: Calendar.current.startOfDay(for: now)).day ?? 0
        XCTAssertEqual(dayCount, 6)
    }
}
