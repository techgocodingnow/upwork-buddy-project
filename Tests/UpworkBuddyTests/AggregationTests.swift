import XCTest
@testable import UpworkBuddy

final class AggregationTests: XCTestCase {
    func testAggregateGroupsByContract() {
        let nodes = [
            TimeReportNode(
                dateWorkedOn: "2026-05-01",
                totalHoursWorked: 2.5,
                totalCharges: .init(amount: 250, currencyCode: "USD"),
                contract: .init(id: "c1", title: "Project A", hourlyChargeRate: .init(amount: 100))
            ),
            TimeReportNode(
                dateWorkedOn: "2026-05-02",
                totalHoursWorked: 1.0,
                totalCharges: .init(amount: 100, currencyCode: "USD"),
                contract: .init(id: "c1", title: "Project A", hourlyChargeRate: .init(amount: 100))
            ),
            TimeReportNode(
                dateWorkedOn: "2026-05-02",
                totalHoursWorked: 3.0,
                totalCharges: .init(amount: 240, currencyCode: "USD"),
                contract: .init(id: "c2", title: "Project B", hourlyChargeRate: .init(amount: 80))
            )
        ]
        let (snapshot, daily) = UpworkAPI.aggregate(nodes: nodes)
        XCTAssertEqual(snapshot.totalHours, 6.5, accuracy: 0.01)
        XCTAssertEqual(snapshot.totalEarnings, 590, accuracy: 0.01)
        XCTAssertEqual(snapshot.projects.count, 2)
        XCTAssertEqual(snapshot.projects.first?.contractId, "c1") // sorted by earnings
        XCTAssertEqual(snapshot.projects.first?.earnings ?? 0, 350, accuracy: 0.01)
        XCTAssertEqual(daily.count, 2)
    }

    func testAggregateSkipsRowsMissingContract() {
        let nodes = [
            TimeReportNode(
                dateWorkedOn: "2026-05-01",
                totalHoursWorked: 2.0,
                totalCharges: .init(amount: 200, currencyCode: "USD"),
                contract: nil
            )
        ]
        let (snapshot, _) = UpworkAPI.aggregate(nodes: nodes)
        XCTAssertEqual(snapshot.projects.count, 0)
        XCTAssertEqual(snapshot.totalEarnings, 0)
    }

    func testDerivedRateFallsBackToEarningsOverHours() {
        let p = ProjectStat(contractId: "x", title: "x", hours: 4, earnings: 200, hourlyRate: nil)
        XCTAssertEqual(p.derivedRate, 50)
    }
}
