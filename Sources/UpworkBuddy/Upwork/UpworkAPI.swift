import Foundation

/// High-level facade over `GraphQLClient`. Returns plain models the UI can render
/// without knowing GraphQL.
struct UpworkAPI: Sendable {
    let client: GraphQLClient

    init(client: GraphQLClient = .shared) {
        self.client = client
    }

    // MARK: - Accounting entity

    /// Resolves the current user's accounting entity ID (the `aceId` required as
    /// `aceIds_any` for `transactionHistory`).
    func fetchAccountingEntityId() async throws -> String {
        struct Resp: Decodable {
            struct Entity: Decodable { let id: String }
            let accountingEntity: Entity?
        }
        let resp = try await client.execute(query: Queries.accountingEntity, as: Resp.self)
        guard let id = resp.accountingEntity?.id else {
            throw UpworkError.transport("accountingEntity returned null")
        }
        return id
    }

    // MARK: - Combined earnings (transactionHistory + contractTimeReport)

    /// Freelancer-side dashboard data for `[range.start, range.end]`.
    /// Runs `transactionHistory` (net earnings/fees) and `contractTimeReport`
    /// (hours, gross, hourly rate) in parallel and merges into one snapshot.
    func fetchCombinedEarnings(
        range: DateRange,
        aceId: String
    ) async throws -> (EarningsSnapshot, [DailyPoint]) {
        async let txTask = fetchTransactionRows(range: range, aceId: aceId)
        async let timeTask = fetchTimeReport(range: range)
        let txRows = try await txTask
        let timeRows = try await timeTask
        return Self.merge(txRows: txRows, timeRows: timeRows)
    }

    // MARK: - transactionHistory

    /// Freelancer-side ledger rows. Used for net earnings + fee adjustments.
    func fetchTransactionRows(range: DateRange, aceId: String) async throws -> [TransactionRow] {
        struct Resp: Decodable {
            struct Detail: Decodable { let transactionHistoryRow: [Row]? }
            struct Row: Decodable {
                let transactionCreationDate: String?
                let type: String?
                let accountingSubtype: String?
                let assignmentDeveloperName: String?
                let assignmentCompanyName: String?
                let assignmentTeamId: String?
                let transactionAmount: Money?
            }
            struct Money: Decodable {
                let rawValue: String?
                let currency: String?
            }
            struct Wrap: Decodable { let transactionDetail: Detail? }
            let transactionHistory: Wrap?
        }

        let variables: [String: JSONValue] = [
            "filter": .object([
                "aceIds_any": .array([.string(aceId)]),
                "transactionDateTime_bt": .object([
                    "rangeStart": .string(Self.isoDateTime(range.start, endOfDay: false)),
                    "rangeEnd": .string(Self.isoDateTime(range.end, endOfDay: true))
                ])
            ])
        ]

        let resp = try await client.execute(
            query: Queries.transactionHistory,
            variables: variables,
            as: Resp.self
        )

        let rawRows = resp.transactionHistory?.transactionDetail?.transactionHistoryRow ?? []
        return rawRows.map { r in
            TransactionRow(
                date: r.transactionCreationDate,
                type: r.type,
                subtype: r.accountingSubtype,
                clientName: r.assignmentCompanyName,
                teamId: r.assignmentTeamId,
                amount: r.transactionAmount?.rawValue.flatMap(Double.init),
                currency: r.transactionAmount?.currency
            )
        }
    }

    // MARK: - contractTimeReport

    /// Freelancer-side per-day hours + gross charges + hourly rate per contract.
    /// Single-page fetch — `pageInfo.hasNextPage` ignored for now (1-month window
    /// is well below typical page size for personal accounts).
    func fetchTimeReport(range: DateRange) async throws -> [TimeReportRow] {
        struct Resp: Decodable {
            struct User: Decodable { let contractTimeReport: Conn? }
            struct Conn: Decodable { let edges: [Edge]? }
            struct Edge: Decodable { let node: Node }
            struct Node: Decodable {
                let dateWorkedOn: String?
                let weekWorkedOn: String?
                let totalHoursWorked: Double?
                let totalCharges: Double?
                let contract: Contract?
            }
            struct Contract: Decodable {
                let id: String?
                let title: String?
                let status: String?
                let clientTeam: ClientTeam?
                let terms: Terms?
            }
            struct ClientTeam: Decodable { let name: String? }
            struct Terms: Decodable { let hourlyTerms: [HourlyTerm]? }
            struct HourlyTerm: Decodable { let hourlyRate: Money? }
            struct Money: Decodable { let rawValue: String?; let currency: String? }
            let user: User?
        }

        let query = Queries.contractTimeReport(
            rangeStart: Self.compactDateString(range.start),
            rangeEnd: Self.compactDateString(range.end)
        )
        let resp = try await client.execute(query: query, as: Resp.self)
        let edges = resp.user?.contractTimeReport?.edges ?? []
        return edges.map { e in
            let topRate = e.node.contract?.terms?.hourlyTerms?.first?.hourlyRate?.rawValue
                .flatMap(Double.init)
            return TimeReportRow(
                dateWorkedOn: e.node.dateWorkedOn,
                hours: e.node.totalHoursWorked,
                charges: e.node.totalCharges,
                contractId: e.node.contract?.id,
                contractTitle: e.node.contract?.title,
                clientName: e.node.contract?.clientTeam?.name,
                hourlyRate: topRate
            )
        }
    }

    // MARK: - Merge

    /// Combine `transactionHistory` rows (net earnings) with `contractTimeReport`
    /// rows (hours, gross, rate) into one snapshot + daily series.
    ///
    /// Project list is keyed by contract.id from the time report; net earnings
    /// from transactionHistory are overlaid by matching `clientTeam.name` to
    /// `assignmentCompanyName`. Transaction rows that don't match any active
    /// contract collapse into residual rows keyed by company name.
    static func merge(
        txRows: [TransactionRow],
        timeRows: [TimeReportRow]
    ) -> (EarningsSnapshot, [DailyPoint]) {
        let cal = Calendar.current

        // ---- contractTimeReport aggregation ----
        struct Agg { var title: String; var clientName: String?; var hours: Double; var gross: Double; var rate: Double? }
        var byContract: [String: Agg] = [:]
        var hoursByDay: [Date: Double] = [:]
        var hoursByDayClient: [Date: [String: Double]] = [:]
        var grossByDayClient: [Date: [String: Double]] = [:]
        var totalHours: Double = 0

        for r in timeRows {
            guard let cid = r.contractId else { continue }
            let hours = r.hours ?? 0
            let charges = r.charges ?? 0
            var entry = byContract[cid] ?? Agg(
                title: r.contractTitle ?? r.clientName ?? "Contract",
                clientName: r.clientName,
                hours: 0,
                gross: 0,
                rate: r.hourlyRate
            )
            entry.hours += hours
            entry.gross += charges
            if entry.rate == nil { entry.rate = r.hourlyRate }
            byContract[cid] = entry
            totalHours += hours
            if let dateStr = r.dateWorkedOn,
               let date = DateRange.iso.date(from: dateStr) {
                let day = cal.startOfDay(for: date)
                hoursByDay[day, default: 0] += hours
                let label = r.clientName ?? r.contractTitle ?? "Contract"
                hoursByDayClient[day, default: [:]][label, default: 0] += hours
                grossByDayClient[day, default: [:]][label, default: 0] += charges
            }
        }

        // ---- transactionHistory aggregation ----
        struct ParsedTx { let date: Date; let clientName: String; let amount: Double }
        let parsedTx: [ParsedTx] = txRows.compactMap { row in
            guard let dateStr = row.date,
                  let date = parseTransactionDate(dateStr),
                  let amount = row.amount,
                  row.type == "APInvoice" || row.type == "APAdjustment" else { return nil }
            let name = row.clientName ?? row.teamId ?? "unknown"
            return ParsedTx(date: date, clientName: name, amount: amount)
        }

        var earningsByClient: [String: Double] = [:]
        var earningsByDay: [Date: Double] = [:]
        var earningsByDayClient: [Date: [String: Double]] = [:]
        for p in parsedTx {
            earningsByClient[p.clientName, default: 0] += p.amount
            let day = cal.startOfDay(for: p.date)
            earningsByDay[day, default: 0] += p.amount
            earningsByDayClient[day, default: [:]][p.clientName, default: 0] += p.amount
        }

        // ---- Build project list ----
        var matchedClients = Set<String>()
        var projects: [ProjectStat] = byContract.map { (cid, agg) in
            var earnings = agg.gross
            if let cname = agg.clientName, let net = earningsByClient[cname] {
                earnings = net
                matchedClients.insert(cname)
            }
            return ProjectStat(
                contractId: cid,
                title: agg.title,
                hours: agg.hours,
                earnings: earnings,
                hourlyRate: agg.rate
            )
        }

        // Residual rows: clients with earnings but no matching active contract.
        for (clientName, amount) in earningsByClient where !matchedClients.contains(clientName) {
            projects.append(ProjectStat(
                contractId: "client:\(clientName)",
                title: clientName,
                hours: 0,
                earnings: amount,
                hourlyRate: nil
            ))
        }
        projects.sort { $0.earnings > $1.earnings }

        // ---- Totals + daily series ----
        let totalEarnings = parsedTx.reduce(0) { $0 + $1.amount }

        let allDays = Set(hoursByDay.keys).union(earningsByDay.keys)
        let daily = allDays
            .map { day -> DailyPoint in
                let earnMap = earningsByDayClient[day] ?? [:]
                let hourMap = hoursByDayClient[day] ?? [:]
                let grossMap = grossByDayClient[day] ?? [:]
                let labels = Set(earnMap.keys).union(hourMap.keys)
                let breakdown = labels.map { label -> DailyBreakdown in
                    let earnings = earnMap[label] ?? grossMap[label] ?? 0
                    return DailyBreakdown(
                        label: label,
                        earnings: earnings,
                        hours: hourMap[label] ?? 0
                    )
                }
                .sorted { $0.earnings == $1.earnings ? $0.hours > $1.hours : $0.earnings > $1.earnings }
                return DailyPoint(
                    date: day,
                    earnings: earningsByDay[day] ?? 0,
                    hours: hoursByDay[day] ?? 0,
                    breakdown: breakdown
                )
            }
            .sorted { $0.date < $1.date }

        let snapshot = EarningsSnapshot(
            totalHours: totalHours,
            totalEarnings: totalEarnings,
            projects: projects,
            generatedAt: Date()
        )
        return (snapshot, daily)
    }

    // MARK: - Date helpers

    nonisolated(unsafe) private static let isoDateTimeFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    nonisolated(unsafe) private static let txDateFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    private static let compactDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone.current
        f.dateFormat = "yyyyMMdd"
        return f
    }()

    /// `timeReportDate_bt` requires compact `YYYYMMDD` strings.
    static func compactDateString(_ date: Date) -> String {
        compactDateFormatter.string(from: date)
    }

    /// `transactionDateTime_bt` requires ISO 8601 date-time strings.
    static func isoDateTime(_ date: Date, endOfDay: Bool) -> String {
        let cal = Calendar(identifier: .gregorian)
        var comps = cal.dateComponents(in: TimeZone(secondsFromGMT: 0) ?? .current, from: date)
        if endOfDay {
            comps.hour = 23; comps.minute = 59; comps.second = 59
        } else {
            comps.hour = 0; comps.minute = 0; comps.second = 0
        }
        let normalized = cal.date(from: comps) ?? date
        return isoDateTimeFormatter.string(from: normalized)
    }

    /// Upwork returns `transactionCreationDate` like `2026-04-26T00:00:00+0000`.
    static func parseTransactionDate(_ s: String) -> Date? {
        if let d = txDateFormatter.date(from: s) { return d }
        // Fallback: trim fractional or non-standard offsets.
        let trimmed = s.replacingOccurrences(of: "+0000", with: "Z")
        return txDateFormatter.date(from: trimmed) ?? DateRange.iso.date(from: String(s.prefix(10)))
    }
}

// MARK: - Public Row type for tests + aggregation

struct TransactionRow: Sendable, Hashable {
    let date: String?
    let type: String?
    let subtype: String?
    let clientName: String?
    let teamId: String?
    let amount: Double?
    let currency: String?
}

struct TimeReportRow: Sendable, Hashable {
    let dateWorkedOn: String?      // "YYYY-MM-DD"
    let hours: Double?
    let charges: Double?           // gross (hours × rate)
    let contractId: String?
    let contractTitle: String?
    let clientName: String?
    let hourlyRate: Double?
}
