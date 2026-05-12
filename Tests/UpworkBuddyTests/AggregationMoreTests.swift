import Testing
import Foundation
@testable import UpworkBuddy

@Suite("UpworkAPI.merge (extended)")
struct AggregationMoreTests {

    @Test func emptyInputsProduceEmptySnapshot() {
        let (snap, daily) = UpworkAPI.merge(txRows: [], timeRows: [])
        #expect(snap.totalHours == 0)
        #expect(snap.totalEarnings == 0)
        #expect(snap.projects.isEmpty)
        #expect(daily.isEmpty)
    }

    @Test func skipsTimeRowsWithoutContractId() {
        let timeRows = [
            TimeReportRow(
                dateWorkedOn: "2026-05-01",
                hours: 2,
                charges: 76,
                contractId: nil,
                contractTitle: "x",
                clientName: "c",
                hourlyRate: 38
            )
        ]
        let (snap, _) = UpworkAPI.merge(txRows: [], timeRows: timeRows)
        #expect(snap.projects.isEmpty)
        #expect(snap.totalHours == 0)
    }

    @Test func ignoresNonInvoiceTransactionTypes() {
        let txRows = [
            TransactionRow(
                date: "2026-05-05T00:00:00+0000",
                type: "SomeOtherType",
                subtype: nil,
                clientName: "Acme",
                teamId: nil,
                amount: 100,
                currency: "USD"
            )
        ]
        let (snap, _) = UpworkAPI.merge(txRows: txRows, timeRows: [])
        // Non APInvoice/APAdjustment → filtered, no residual project.
        #expect(snap.projects.isEmpty)
    }

    @Test func acceptsAPAdjustmentRows() {
        let txRows = [
            TransactionRow(
                date: "2026-05-05T00:00:00+0000",
                type: "APAdjustment",
                subtype: "Refund",
                clientName: "Acme",
                teamId: nil,
                amount: -25,
                currency: "USD"
            )
        ]
        let (snap, _) = UpworkAPI.merge(txRows: txRows, timeRows: [])
        #expect(snap.projects.count == 1)
        #expect(snap.projects.first?.earnings == -25)
    }

    @Test func usesTeamIdAsFallbackName() {
        let txRows = [
            TransactionRow(
                date: "2026-05-05T00:00:00+0000",
                type: "APInvoice",
                subtype: nil,
                clientName: nil,
                teamId: "team-xyz",
                amount: 100,
                currency: "USD"
            )
        ]
        let (snap, _) = UpworkAPI.merge(txRows: txRows, timeRows: [])
        #expect(snap.projects.count == 1)
        #expect(snap.projects.first?.title == "team-xyz")
    }

    @Test func projectsSortedByEarningsDescending() {
        let txRows = [
            TransactionRow(date: "2026-05-01T00:00:00+0000", type: "APInvoice", subtype: nil,
                           clientName: "Small", teamId: nil, amount: 10, currency: "USD"),
            TransactionRow(date: "2026-05-01T00:00:00+0000", type: "APInvoice", subtype: nil,
                           clientName: "Big", teamId: nil, amount: 1000, currency: "USD"),
            TransactionRow(date: "2026-05-01T00:00:00+0000", type: "APInvoice", subtype: nil,
                           clientName: "Mid", teamId: nil, amount: 100, currency: "USD"),
        ]
        let (snap, _) = UpworkAPI.merge(txRows: txRows, timeRows: [])
        #expect(snap.projects.map(\.title) == ["Big", "Mid", "Small"])
    }

    @Test func dailySeriesSortedByDate() {
        let timeRows = [
            TimeReportRow(dateWorkedOn: "2026-05-03", hours: 1, charges: 38,
                          contractId: "c1", contractTitle: "T", clientName: "C", hourlyRate: 38),
            TimeReportRow(dateWorkedOn: "2026-05-01", hours: 1, charges: 38,
                          contractId: "c1", contractTitle: "T", clientName: "C", hourlyRate: 38),
            TimeReportRow(dateWorkedOn: "2026-05-02", hours: 1, charges: 38,
                          contractId: "c1", contractTitle: "T", clientName: "C", hourlyRate: 38),
        ]
        let (_, daily) = UpworkAPI.merge(txRows: [], timeRows: timeRows)
        #expect(daily.count == 3)
        for i in 0..<(daily.count - 1) {
            #expect(daily[i].date < daily[i + 1].date)
        }
    }

    @Test func filterDateExcludesOtherDaysFromTotals() {
        let timeRows = [
            TimeReportRow(dateWorkedOn: "2026-05-01", hours: 1, charges: 38,
                          contractId: "c1", contractTitle: "T", clientName: "C", hourlyRate: 38),
            TimeReportRow(dateWorkedOn: "2026-05-03", hours: 5, charges: 190,
                          contractId: "c1", contractTitle: "T", clientName: "C", hourlyRate: 38),
        ]
        let cal = Calendar.current
        let filterDate = cal.startOfDay(for: DateRange.iso.date(from: "2026-05-03")!)
        let (snap, daily) = UpworkAPI.merge(txRows: [], timeRows: timeRows, filterDate: filterDate)
        // Only 5/3 counts toward totals.
        #expect(snap.totalHours == 5)
        // But daily series still includes both days for sparkline use.
        #expect(daily.count == 2)
    }

    @Test func parseTransactionDateAcceptsPlainISO() {
        let d = UpworkAPI.parseTransactionDate("2026-05-05T00:00:00+0000")
        #expect(d != nil)
    }

    @Test func parseTransactionDateFallsBackToYMD() {
        let d = UpworkAPI.parseTransactionDate("2026-05-05")
        #expect(d != nil)
    }

    @Test func compactDateStringFormat() {
        let d = DateRange.iso.date(from: "2026-05-12")!
        #expect(UpworkAPI.compactDateString(d) == "20260512")
    }

    @Test func dailyBreakdownPreservesClientLabel() {
        let timeRows = [
            TimeReportRow(dateWorkedOn: "2026-05-01", hours: 1, charges: 38,
                          contractId: "c1", contractTitle: "T", clientName: "Acme", hourlyRate: 38),
            TimeReportRow(dateWorkedOn: "2026-05-01", hours: 2, charges: 76,
                          contractId: "c2", contractTitle: "T2", clientName: "Beta", hourlyRate: 38),
        ]
        let (_, daily) = UpworkAPI.merge(txRows: [], timeRows: timeRows)
        #expect(daily.count == 1)
        let labels = Set(daily.first?.breakdown.map(\.label) ?? [])
        #expect(labels == ["Acme", "Beta"])
    }
}
