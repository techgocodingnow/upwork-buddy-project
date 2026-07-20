import Foundation
import Testing
@testable import UpworkBuddy

@Suite("UpworkAPI time report pagination")
struct TimeReportPaginationTests {
    @Test func fetchTimeReportLoadsEveryPage() async throws {
        let executor = StubGraphQLExecutor(payloads: [
            """
            {
              "user": {
                "contractTimeReport": {
                  "edges": [
                    {
                      "node": {
                        "dateWorkedOn": "2026-03-31",
                        "totalHoursWorked": 2
                      }
                    }
                  ],
                  "pageInfo": {
                    "endCursor": "cursor-1",
                    "hasNextPage": true
                  }
                }
              }
            }
            """,
            """
            {
              "user": {
                "contractTimeReport": {
                  "edges": [
                    {
                      "node": {
                        "dateWorkedOn": "2026-04-01",
                        "totalHoursWorked": 3
                      }
                    }
                  ],
                  "pageInfo": {
                    "endCursor": "cursor-2",
                    "hasNextPage": false
                  }
                }
              }
            }
            """
        ])
        let api = UpworkAPI(client: executor)
        let range = DateRange(
            start: try #require(DateRange.iso.date(from: "2026-01-01")),
            end: try #require(DateRange.iso.date(from: "2026-12-31"))
        )

        let rows = try await api.fetchTimeReport(range: range)
        let queries = await executor.capturedQueries()

        #expect(rows.map(\.dateWorkedOn) == ["2026-03-31", "2026-04-01"])
        #expect(queries.count == 2)
        let firstQuery = try #require(queries.first)
        let secondQuery = try #require(queries.dropFirst().first)
        #expect(firstQuery.contains("pagination: { first: 100 }"))
        #expect(secondQuery.contains(#"pagination: { first: 100, after: "cursor-1" }"#))
    }
}

private actor StubGraphQLExecutor: GraphQLExecuting {
    private var payloads: [Data]
    private var queries: [String] = []

    init(payloads: [String]) {
        self.payloads = payloads.map { Data($0.utf8) }
    }

    func execute<T: Decodable & Sendable>(
        query: String,
        variables: [String: JSONValue],
        as type: T.Type
    ) async throws -> T {
        queries.append(query)
        guard !payloads.isEmpty else {
            throw UpworkError.transport("Stub received more requests than expected")
        }
        return try JSONDecoder().decode(T.self, from: payloads.removeFirst())
    }

    func capturedQueries() -> [String] {
        queries
    }
}
