import Testing
import Foundation
@testable import UpworkBuddy

@MainActor
@Suite("GoalNotificationService.bucketKey")
struct GoalBucketKeyTests {

    private let utc = TimeZone(identifier: "UTC")!

    private func date(_ s: String) -> Date {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f.date(from: s)!
    }

    @Test func todayBucketIsCalendarDate() {
        let key = GoalNotificationService.bucketKey(
            for: .today,
            on: date("2026-05-12 15:30:00"),
            timeZone: utc
        )
        #expect(key == "2026-05-12")
    }

    @Test func todayBucketChangesAtMidnight() {
        let beforeMidnight = GoalNotificationService.bucketKey(
            for: .today,
            on: date("2026-05-12 23:59:59"),
            timeZone: utc
        )
        let afterMidnight = GoalNotificationService.bucketKey(
            for: .today,
            on: date("2026-05-13 00:00:01"),
            timeZone: utc
        )
        #expect(beforeMidnight != afterMidnight)
        #expect(afterMidnight == "2026-05-13")
    }

    @Test func weekBucketIsISOYearAndWeek() {
        // 2026-05-12 is in ISO week 20 of 2026.
        let key = GoalNotificationService.bucketKey(
            for: .week,
            on: date("2026-05-12 12:00:00"),
            timeZone: utc
        )
        #expect(key == "2026-W20")
    }

    @Test func weekBucketStableAcrossDaysSameWeek() {
        let mon = GoalNotificationService.bucketKey(for: .week, on: date("2026-05-11 09:00:00"), timeZone: utc)
        let sun = GoalNotificationService.bucketKey(for: .week, on: date("2026-05-17 09:00:00"), timeZone: utc)
        #expect(mon == sun)
    }

    @Test func weekBucketChangesAtWeekBoundary() {
        // 2026-05-17 is Sunday (ISO week 20); 2026-05-18 is Monday (ISO week 21).
        let sun = GoalNotificationService.bucketKey(for: .week, on: date("2026-05-17 23:00:00"), timeZone: utc)
        let mon = GoalNotificationService.bucketKey(for: .week, on: date("2026-05-18 01:00:00"), timeZone: utc)
        #expect(sun != mon)
    }

    @Test func monthBucketFormat() {
        let key = GoalNotificationService.bucketKey(
            for: .month,
            on: date("2026-05-12 12:00:00"),
            timeZone: utc
        )
        #expect(key == "2026-05")
    }

    @Test func monthBucketChangesOnMonthRollover() {
        let apr = GoalNotificationService.bucketKey(for: .month, on: date("2026-04-30 23:00:00"), timeZone: utc)
        let may = GoalNotificationService.bucketKey(for: .month, on: date("2026-05-01 01:00:00"), timeZone: utc)
        #expect(apr == "2026-04")
        #expect(may == "2026-05")
    }

    @Test func yearBucketIsCalendarYear() {
        let key = GoalNotificationService.bucketKey(
            for: .year,
            on: date("2026-05-12 12:00:00"),
            timeZone: utc
        )
        #expect(key == "2026")
    }

    @Test func yearBucketChangesAtNewYear() {
        let prev = GoalNotificationService.bucketKey(for: .year, on: date("2025-12-31 23:00:00"), timeZone: utc)
        let next = GoalNotificationService.bucketKey(for: .year, on: date("2026-01-01 01:00:00"), timeZone: utc)
        #expect(prev != next)
    }

    @Test func thresholdRequiresObservedCrossing() {
        #expect(!GoalNotificationService.crossedThreshold(previous: nil, current: 120, threshold: 100))
        #expect(GoalNotificationService.crossedThreshold(previous: 0, current: 100, threshold: 100))
        #expect(GoalNotificationService.crossedThreshold(previous: 99, current: 100, threshold: 100))
        #expect(!GoalNotificationService.crossedThreshold(previous: 100, current: 120, threshold: 100))
        #expect(!GoalNotificationService.crossedThreshold(previous: 80, current: 90, threshold: 100))
    }
}
