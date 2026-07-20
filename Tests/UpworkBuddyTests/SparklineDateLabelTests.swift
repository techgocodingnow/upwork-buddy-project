import Foundation
import Testing
@testable import UpworkBuddy

@Suite("Sparkline date labels")
struct SparklineDateLabelTests {
    private let locale = Locale(identifier: "en_US_POSIX")
    private let timeZone = TimeZone(secondsFromGMT: 0)!

    @Test func yearUsesMonthNameOnly() {
        let label = SparklineDateLabelFormatter.string(
            for: juneFirst2026,
            period: .year,
            locale: locale,
            timeZone: timeZone
        )

        #expect(label == "Jun")
    }

    @Test func shorterPeriodsKeepWeekdayAndDay() {
        let label = SparklineDateLabelFormatter.string(
            for: juneFirst2026,
            period: .month,
            locale: locale,
            timeZone: timeZone
        )

        #expect(label.contains("Mon"))
        #expect(label.contains("Jun"))
        #expect(label.contains("1"))
    }

    private var juneFirst2026: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar.date(from: DateComponents(year: 2026, month: 6, day: 1))!
    }
}
