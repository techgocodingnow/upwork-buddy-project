import Testing
@testable import UpworkBuddy

@Suite("Period")
struct PeriodTests {

    @Test func sparklineDaysPerCase() {
        #expect(Period.today.sparklineDays == 7)
        #expect(Period.week.sparklineDays == 7)
        #expect(Period.month.sparklineDays == 30)
        #expect(Period.year.sparklineDays == 90)
    }

    @Test func allCasesEnumerateExpected() {
        #expect(Period.allCases == [.today, .week, .month, .year])
    }

    @Test func idMatchesRawValue() {
        for p in Period.allCases {
            #expect(p.id == p.rawValue)
        }
    }

    @Test func labelNotEmpty() {
        for p in Period.allCases {
            #expect(!p.label.isEmpty)
        }
    }
}
