import XCTest
@testable import UpworkBuddy

final class AggregationTests: XCTestCase {

    // MARK: - merge(txRows:timeRows:)

    func testMergeGroupsTimeRowsByContract() {
        let timeRows = [
            TimeReportRow(
                dateWorkedOn: "2026-05-01",
                hours: 3.6666666666666665,
                charges: 139.333333,
                contractId: "39014862",
                contractTitle: "RN Mobile",
                clientName: "ServiceMonster",
                hourlyRate: 38
            ),
            TimeReportRow(
                dateWorkedOn: "2026-05-03",
                hours: 2.0,
                charges: 76,
                contractId: "39014862",
                contractTitle: "RN Mobile",
                clientName: "ServiceMonster",
                hourlyRate: 38
            ),
            TimeReportRow(
                dateWorkedOn: "2026-05-04",
                hours: 4.666666666666667,
                charges: 177.333333,
                contractId: "39014862",
                contractTitle: "RN Mobile",
                clientName: "ServiceMonster",
                hourlyRate: 38
            ),
            TimeReportRow(
                dateWorkedOn: "2026-05-04",
                hours: 2.3333333333333335,
                charges: 81.666667,
                contractId: "39014885",
                contractTitle: "RN Mobile",
                clientName: "Xcelerate Restoration Software",
                hourlyRate: 35
            )
        ]
        let (snapshot, daily) = UpworkAPI.merge(txRows: [], timeRows: timeRows)

        XCTAssertEqual(snapshot.totalHours, 12.6667, accuracy: 0.01)
        XCTAssertEqual(snapshot.projects.count, 2)
        // No transactionHistory rows, so earnings == gross charges.
        let sm = snapshot.projects.first { $0.contractId == "39014862" }
        XCTAssertNotNil(sm)
        XCTAssertEqual(sm?.hours ?? 0, 10.3333, accuracy: 0.01)
        XCTAssertEqual(sm?.earnings ?? 0, 392.67, accuracy: 0.01)
        XCTAssertEqual(sm?.hourlyRate ?? 0, 38)

        let xc = snapshot.projects.first { $0.contractId == "39014885" }
        XCTAssertEqual(xc?.hours ?? 0, 2.3333, accuracy: 0.01)
        XCTAssertEqual(xc?.hourlyRate ?? 0, 35)

        // 3 distinct workdays (5/1, 5/3, 5/4).
        XCTAssertEqual(daily.count, 3)

        // Hero / menubar total must reflect gross when no transactions have posted.
        let projectsSum = snapshot.projects.reduce(0) { $0 + $1.earnings }
        XCTAssertEqual(snapshot.totalEarnings, projectsSum, accuracy: 0.01)
        XCTAssertGreaterThan(snapshot.totalEarnings, 0)
    }

    func testMergeOverlaysNetEarningsByClientName() {
        let timeRows = [
            TimeReportRow(
                dateWorkedOn: "2026-05-01",
                hours: 10,
                charges: 380,
                contractId: "c1",
                contractTitle: "Job",
                clientName: "Acme",
                hourlyRate: 38
            )
        ]
        let txRows = [
            TransactionRow(
                date: "2026-05-05T00:00:00+0000",
                type: "APInvoice",
                subtype: "Hourly",
                clientName: "Acme",
                teamId: "team-1",
                amount: 320,
                currency: "USD"
            )
        ]
        let (snapshot, _) = UpworkAPI.merge(txRows: txRows, timeRows: timeRows)
        let acme = snapshot.projects.first { $0.contractId == "c1" }
        XCTAssertEqual(acme?.hours ?? 0, 10)
        // earnings replaced by net from transactionHistory, not gross charges.
        XCTAssertEqual(acme?.earnings ?? 0, 320, accuracy: 0.01)
        XCTAssertEqual(snapshot.totalEarnings, 320, accuracy: 0.01)
    }

    func testMergeKeepsResidualEarningsWithoutContractMatch() {
        let txRows = [
            TransactionRow(
                date: "2026-05-05T00:00:00+0000",
                type: "APInvoice",
                subtype: "Bonus",
                clientName: "MysteryCorp",
                teamId: nil,
                amount: 50,
                currency: "USD"
            )
        ]
        let (snapshot, _) = UpworkAPI.merge(txRows: txRows, timeRows: [])
        XCTAssertEqual(snapshot.projects.count, 1)
        XCTAssertEqual(snapshot.projects.first?.title, "MysteryCorp")
        XCTAssertEqual(snapshot.projects.first?.earnings ?? 0, 50)
        XCTAssertEqual(snapshot.totalHours, 0)
    }

    // MARK: - overlayWorkDiary (live current-day hours)

    func testOverlayUsesLiveHoursWhenReportLagsAtZero() {
        let day = Date()
        let dayStr = DateRange.iso.string(from: day)
        // contract seen earlier in the week, but no row for `day` yet (report lag).
        let timeRows = [
            TimeReportRow(dateWorkedOn: "2026-05-18", hours: 5, charges: 190,
                          contractId: "c1", contractTitle: "Job", clientName: "Acme",
                          hourlyRate: 38)
        ]
        let result = UpworkAPI.overlayWorkDiary(
            timeRows: timeRows, day: day, liveHours: ["c1": 2.0])

        let todayRow = result.first { $0.dateWorkedOn == dayStr }
        XCTAssertEqual(todayRow?.hours ?? 0, 2.0, accuracy: 0.001)
        XCTAssertEqual(todayRow?.charges ?? 0, 76, accuracy: 0.001) // 2h * 38
        XCTAssertEqual(todayRow?.contractTitle, "Job")
        XCTAssertEqual(todayRow?.hourlyRate, 38)
    }

    func testOverlayKeepsReportHoursWhenGreaterThanLive() {
        let day = Date()
        let dayStr = DateRange.iso.string(from: day)
        let timeRows = [
            TimeReportRow(dateWorkedOn: dayStr, hours: 4, charges: 152,
                          contractId: "c1", contractTitle: "Job", clientName: "Acme",
                          hourlyRate: 38)
        ]
        // Live diary lags behind the already-posted report — report must win.
        let result = UpworkAPI.overlayWorkDiary(
            timeRows: timeRows, day: day, liveHours: ["c1": 1.0])

        let todayRows = result.filter { $0.dateWorkedOn == dayStr }
        XCTAssertEqual(todayRows.count, 1)
        XCTAssertEqual(todayRows.first?.hours ?? 0, 4, accuracy: 0.001)
    }

    func testOverlayFallsBackToReportWhenLiveFetchFailed() {
        let day = Date()
        let dayStr = DateRange.iso.string(from: day)
        let timeRows = [
            TimeReportRow(dateWorkedOn: dayStr, hours: 3, charges: 114,
                          contractId: "c1", contractTitle: "Job", clientName: "Acme",
                          hourlyRate: 38)
        ]
        // A failed diary fetch surfaces as 0 — report hours must be preserved.
        let result = UpworkAPI.overlayWorkDiary(
            timeRows: timeRows, day: day, liveHours: ["c1": 0])

        XCTAssertEqual(result.first { $0.dateWorkedOn == dayStr }?.hours ?? 0,
                       3, accuracy: 0.001)
    }

    func testOverlayLeavesOtherDaysUnchanged() {
        let day = Date()
        let timeRows = [
            TimeReportRow(dateWorkedOn: "2026-05-18", hours: 5, charges: 190,
                          contractId: "c1", contractTitle: "Job", clientName: "Acme",
                          hourlyRate: 38),
            TimeReportRow(dateWorkedOn: "2026-05-19", hours: 6, charges: 228,
                          contractId: "c1", contractTitle: "Job", clientName: "Acme",
                          hourlyRate: 38)
        ]
        let result = UpworkAPI.overlayWorkDiary(
            timeRows: timeRows, day: day, liveHours: ["c1": 2.0])

        XCTAssertEqual(result.first { $0.dateWorkedOn == "2026-05-18" }?.hours, 5)
        XCTAssertEqual(result.first { $0.dateWorkedOn == "2026-05-19" }?.hours, 6)
    }

    // MARK: - ProjectStat helpers

    func testDerivedRateFallsBackToEarningsOverHours() {
        let p = ProjectStat(contractId: "x", title: "x", hours: 4, earnings: 200, hourlyRate: nil)
        XCTAssertEqual(p.derivedRate, 50)
    }
}
