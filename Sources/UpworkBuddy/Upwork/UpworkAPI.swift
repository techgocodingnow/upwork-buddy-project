import Foundation

/// High-level facade over `GraphQLClient`. Returns plain models the UI can render
/// without knowing GraphQL.
struct UpworkAPI: Sendable {
    let client: GraphQLClient

    init(client: GraphQLClient = .shared) {
        self.client = client
    }

    // MARK: - Tenants

    func fetchTenants() async throws -> [Tenant] {
        struct Resp: Decodable {
            struct Selector: Decodable { let items: [Tenant] }
            let companySelector: Selector?
        }
        let resp = try await client.execute(query: Queries.companySelector, as: Resp.self)
        return resp.companySelector?.items ?? []
    }

    // MARK: - Time report

    /// Hourly time + charges for `[range.start, range.end]`. Returns aggregated snapshot
    /// (per-contract totals) plus per-day series for sparklines.
    func fetchTimeReport(range: DateRange, organizationId: String) async throws -> (EarningsSnapshot, [DailyPoint]) {
        struct Resp: Decodable {
            struct Edges: Decodable { let edges: [Edge] }
            struct Edge: Decodable { let node: Node }
            struct Node: Decodable {
                let dateWorkedOn: String
                let totalHoursWorked: Double?
                let totalCharges: Double?
                let contract: ContractRef?
            }
            struct ContractRef: Decodable {
                let id: String
                let title: String?
            }
            let contractTimeReport: Edges?
        }

        let variables: [String: JSONValue] = [
            "filter": .object([
                "organizationId_eq": .string(organizationId),
                "timeReportDate_bt": .object([
                    "rangeStart": .string(range.startString),
                    "rangeEnd": .string(range.endString)
                ])
            ])
        ]

        let resp = try await client.execute(
            query: Queries.contractTimeReport,
            variables: variables,
            as: Resp.self
        )

        let nodes: [TimeReportNode] = (resp.contractTimeReport?.edges ?? []).map { edge in
            TimeReportNode(
                dateWorkedOn: edge.node.dateWorkedOn,
                totalHoursWorked: edge.node.totalHoursWorked,
                totalCharges: edge.node.totalCharges.map {
                    TimeReportNode.Money(amount: $0, currencyCode: nil)
                },
                contract: edge.node.contract.map {
                    TimeReportNode.ContractRef(
                        id: $0.id,
                        title: $0.title,
                        hourlyChargeRate: nil
                    )
                }
            )
        }
        return Self.aggregate(nodes: nodes)
    }

    // MARK: - Aggregation

    static func aggregate(nodes: [TimeReportNode]) -> (EarningsSnapshot, [DailyPoint]) {
        struct Row {
            let date: Date
            let contractId: String
            let title: String
            let hours: Double
            let earnings: Double
            let hourlyRate: Double?
        }

        let rows: [Row] = nodes.compactMap { node in
            guard let id = node.contract?.id,
                  let parsed = DateRange.iso.date(from: node.dateWorkedOn) else { return nil }
            return Row(
                date: parsed,
                contractId: id,
                title: node.contract?.title ?? id,
                hours: node.totalHoursWorked ?? 0,
                earnings: node.totalCharges?.amount ?? 0,
                hourlyRate: node.contract?.hourlyChargeRate?.amount
            )
        }

        var byContract: [String: (title: String, hours: Double, earnings: Double, rate: Double?)] = [:]
        for row in rows {
            var entry = byContract[row.contractId] ?? (row.title, 0, 0, row.hourlyRate)
            entry.hours += row.hours
            entry.earnings += row.earnings
            entry.title = row.title
            if entry.rate == nil { entry.rate = row.hourlyRate }
            byContract[row.contractId] = entry
        }

        let projects = byContract
            .map { (id, v) in
                ProjectStat(
                    contractId: id,
                    title: v.title,
                    hours: v.hours,
                    earnings: v.earnings,
                    hourlyRate: v.rate
                )
            }
            .sorted { $0.earnings > $1.earnings }

        let totalHours = projects.reduce(0) { $0 + $1.hours }
        let totalEarnings = projects.reduce(0) { $0 + $1.earnings }

        var byDay: [Date: (hours: Double, earnings: Double)] = [:]
        let cal = Calendar.current
        for row in rows {
            let day = cal.startOfDay(for: row.date)
            var entry = byDay[day] ?? (0, 0)
            entry.hours += row.hours
            entry.earnings += row.earnings
            byDay[day] = entry
        }
        let daily = byDay
            .map { DailyPoint(date: $0.key, earnings: $0.value.earnings, hours: $0.value.hours) }
            .sorted { $0.date < $1.date }

        let snapshot = EarningsSnapshot(
            totalHours: totalHours,
            totalEarnings: totalEarnings,
            projects: projects,
            generatedAt: Date()
        )
        return (snapshot, daily)
    }
}

// MARK: - Public Node type for tests + aggregation

struct TimeReportNode: Sendable {
    struct Money: Sendable { let amount: Double?; let currencyCode: String? }
    struct ContractRef: Sendable {
        struct Rate: Sendable { let amount: Double? }
        let id: String
        let title: String?
        let hourlyChargeRate: Rate?
    }
    let dateWorkedOn: String
    let totalHoursWorked: Double?
    let totalCharges: Money?
    let contract: ContractRef?
}
