import Testing
@testable import UpworkBuddy

@Suite("ProjectStat.derivedRate")
struct ProjectStatTests {

    @Test func usesExplicitRateWhenPositive() {
        let p = ProjectStat(contractId: "c1", title: "T", hours: 5, earnings: 200, hourlyRate: 40)
        #expect(p.derivedRate == 40)
    }

    @Test func fallsBackToEarningsPerHourWhenRateZero() {
        let p = ProjectStat(contractId: "c1", title: "T", hours: 4, earnings: 200, hourlyRate: 0)
        #expect(p.derivedRate == 50)
    }

    @Test func fallsBackToEarningsPerHourWhenRateNil() {
        let p = ProjectStat(contractId: "c1", title: "T", hours: 8, earnings: 320, hourlyRate: nil)
        #expect(p.derivedRate == 40)
    }

    @Test func zeroWhenHoursZeroAndNoRate() {
        let p = ProjectStat(contractId: "c1", title: "T", hours: 0, earnings: 100, hourlyRate: nil)
        #expect(p.derivedRate == 0)
    }

    @Test func zeroWhenHoursAndRateZero() {
        let p = ProjectStat(contractId: "c1", title: "T", hours: 0, earnings: 0, hourlyRate: 0)
        #expect(p.derivedRate == 0)
    }

    @Test func negativeRateTreatedAsUnset() {
        let p = ProjectStat(contractId: "c1", title: "T", hours: 2, earnings: 100, hourlyRate: -5)
        #expect(p.derivedRate == 50)
    }

    @Test func idEqualsContractId() {
        let p = ProjectStat(contractId: "abc-123", title: "T", hours: 1, earnings: 1, hourlyRate: nil)
        #expect(p.id == "abc-123")
    }
}
