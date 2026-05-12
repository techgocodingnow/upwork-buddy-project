import Testing
import Foundation
@testable import UpworkBuddy

@MainActor
@Suite("MenuBarMetricFormatter", .serialized)
struct MenuBarMetricFormatterTests {

    private func makeStore(
        currency: String = "USD",
        masked: Bool = false,
        metric: MenuBarMetric = .hours,
        goalsEnabled: Bool = true,
        hoursWeekly: Double = 0,
        earningsWeekly: Double = 0
    ) -> AppStore {
        let s = AppStore()
        s.currency = currency
        s.hideSensitive = masked
        s.menuBarMetric = metric
        s.goalsEnabled = goalsEnabled
        s.goalHoursWeekly = hoursWeekly
        s.goalEarningsWeekly = earningsWeekly
        return s
    }

    private func snap(hours: Double = 0, earnings: Double = 0) -> EarningsSnapshot {
        EarningsSnapshot(
            totalHours: hours,
            totalEarnings: earnings,
            projects: [],
            generatedAt: Date()
        )
    }

    // MARK: - progress

    @Test func progressUsesHoursWhenHoursGoalSet() {
        let store = makeStore(hoursWeekly: 10)
        let p = MenuBarMetricFormatter.progress(
            snapshot: snap(hours: 5),
            period: .week,
            store: store
        )
        #expect(p == 0.5)
    }

    @Test func progressFallsBackToEarningsWhenNoHoursGoal() {
        let store = makeStore(hoursWeekly: 0, earningsWeekly: 1000)
        let p = MenuBarMetricFormatter.progress(
            snapshot: snap(earnings: 250),
            period: .week,
            store: store
        )
        #expect(p == 0.25)
    }

    @Test func progressZeroWhenNoGoals() {
        let store = makeStore()
        let p = MenuBarMetricFormatter.progress(
            snapshot: snap(hours: 10),
            period: .week,
            store: store
        )
        #expect(p == 0)
    }

    @Test func progressZeroWhenGoalsDisabled() {
        let store = makeStore(goalsEnabled: false, hoursWeekly: 10)
        let p = MenuBarMetricFormatter.progress(
            snapshot: snap(hours: 5),
            period: .week,
            store: store
        )
        #expect(p == 0)
    }

    // MARK: - label percentage

    @Test func percentageLabelEmDashWhenZero() {
        let store = makeStore()
        let s = MenuBarMetricFormatter.label(
            snapshot: snap(),
            period: .week,
            store: store,
            mode: .percentage
        )
        #expect(s == "—")
    }

    @Test func percentageRoundsToWholeInt() {
        let store = makeStore(hoursWeekly: 10)
        let s = MenuBarMetricFormatter.label(
            snapshot: snap(hours: 6),
            period: .week,
            store: store,
            mode: .percentage
        )
        #expect(s == "60%")
    }

    @Test func percentageClampsAt999() {
        let store = makeStore(hoursWeekly: 1)
        let s = MenuBarMetricFormatter.label(
            snapshot: snap(hours: 1000),
            period: .week,
            store: store,
            mode: .percentage
        )
        #expect(s == "999%")
    }

    // MARK: - label count

    @Test func countModeHoursGoal() {
        let store = makeStore(hoursWeekly: 8)
        let s = MenuBarMetricFormatter.label(
            snapshot: snap(hours: 5),
            period: .week,
            store: store,
            mode: .count
        )
        #expect(s == "5h/8h")
    }

    @Test func countModeFallsBackToEarningsGoal() {
        let store = makeStore(hoursWeekly: 0, earningsWeekly: 500)
        let s = MenuBarMetricFormatter.label(
            snapshot: snap(earnings: 200),
            period: .week,
            store: store,
            mode: .count
        )
        #expect(s.contains("/"))
        #expect(s.contains("$"))
    }

    @Test func countModeNoGoalFallsBackToRawHours() {
        let store = makeStore()
        let s = MenuBarMetricFormatter.label(
            snapshot: snap(hours: 3),
            period: .week,
            store: store,
            mode: .count
        )
        #expect(s == "3h")
    }

    @Test func countModeNoGoalNoHoursFallsBackToCompactEarnings() {
        let store = makeStore()
        let s = MenuBarMetricFormatter.label(
            snapshot: snap(earnings: 42),
            period: .week,
            store: store,
            mode: .count
        )
        #expect(s.contains("42"))
        #expect(s.contains("$"))
    }

    // MARK: - primaryLabel

    @Test func primaryLabelHoursMetric() {
        let store = makeStore(metric: .hours)
        let s = MenuBarMetricFormatter.primaryLabel(
            snapshot: snap(hours: 4),
            store: store
        )
        #expect(s == "4h")
    }

    @Test func primaryLabelEarningsMetric() {
        let store = makeStore(metric: .earnings)
        let s = MenuBarMetricFormatter.primaryLabel(
            snapshot: snap(earnings: 80),
            store: store
        )
        #expect(s.contains("80"))
        #expect(s.contains("$"))
    }

    // MARK: - remainingLabel

    @Test func remainingHoursWhenGoalUnset() {
        let store = makeStore(metric: .hours)
        let s = MenuBarMetricFormatter.remainingLabel(
            snapshot: snap(hours: 1),
            period: .week,
            store: store
        )
        #expect(s == "—")
    }

    @Test func remainingHoursClampsToZero() {
        let store = makeStore(metric: .hours, hoursWeekly: 8)
        let s = MenuBarMetricFormatter.remainingLabel(
            snapshot: snap(hours: 12),
            period: .week,
            store: store
        )
        #expect(s == "0h")
    }

    @Test func remainingHoursRendersGap() {
        let store = makeStore(metric: .hours, hoursWeekly: 10)
        let s = MenuBarMetricFormatter.remainingLabel(
            snapshot: snap(hours: 3),
            period: .week,
            store: store
        )
        #expect(s == "7h")
    }

    @Test func remainingEarningsRendersGap() {
        let store = makeStore(metric: .earnings, earningsWeekly: 500)
        let s = MenuBarMetricFormatter.remainingLabel(
            snapshot: snap(earnings: 200),
            period: .week,
            store: store
        )
        #expect(s.contains("300"))
        #expect(s.contains("$"))
    }

    @Test func remainingEarningsClampsToZero() {
        let store = makeStore(metric: .earnings, earningsWeekly: 500)
        let s = MenuBarMetricFormatter.remainingLabel(
            snapshot: snap(earnings: 999),
            period: .week,
            store: store
        )
        // 0 < 100 → 2 fraction digits in compact path
        #expect(s.contains("0"))
        #expect(s.contains("$"))
    }

    // MARK: - hours formatting branches via primaryLabel

    @Test func primaryHoursRendersFractionalAtThreshold() {
        let store = makeStore(metric: .hours)
        // 1.5 → frac >= 0.05 → "1.5h"
        let s = MenuBarMetricFormatter.primaryLabel(
            snapshot: snap(hours: 1.5),
            store: store
        )
        #expect(s == "1.5h")
    }

    @Test func primaryHoursDropsTinyFraction() {
        let store = makeStore(metric: .hours)
        // 2.01 → frac < 0.05 → "2h"
        let s = MenuBarMetricFormatter.primaryLabel(
            snapshot: snap(hours: 2.01),
            store: store
        )
        #expect(s == "2h")
    }

    @Test func primaryHoursZero() {
        let store = makeStore(metric: .hours)
        let s = MenuBarMetricFormatter.primaryLabel(
            snapshot: snap(hours: 0),
            store: store
        )
        #expect(s == "0h")
    }
}
