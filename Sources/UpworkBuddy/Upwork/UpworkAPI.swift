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
    ///
    /// The time report query is expanded to the enclosing Upwork week when the
    /// range spans a single day. Upwork's `timeReportDate_bt` filter appears to
    /// match on `weekWorkedOn` (Monday-aligned), so a same-day range would miss
    /// the current week's data otherwise. The snapshot totals are then filtered
    /// back to `range` via `merge(filterDate:)`.
    func fetchCombinedEarnings(
        range: DateRange,
        aceId: String
    ) async throws -> (EarningsSnapshot, [DailyPoint]) {
        let timeRange = Self.weekExpandedRange(for: range)
        let filterDate: Date? = timeRange.start < range.start ? range.start : nil
        async let txTask = fetchTransactionRows(range: range, aceId: aceId)
        async let timeTask = fetchTimeReport(range: timeRange)
        let txRows = try await txTask
        var timeRows = try await timeTask

        // `contractTimeReport` lags hours behind for the in-progress current day.
        // For a single-day range that is today, overlay Work Diary hours (archived
        // ~live) so "Today" reflects tracked time instead of a stale 0.
        let cal = Calendar.current
        if cal.isDate(range.start, inSameDayAs: range.end), cal.isDateInToday(range.start) {
            timeRows = await augmentWithWorkDiary(timeRows: timeRows, day: range.start)
        }

        return Self.merge(txRows: txRows, timeRows: timeRows, filterDate: filterDate)
    }

    // MARK: - Work Diary (live current-day hours)

    /// Logged hours for one contract on one day via the Work Diary. Each time cell
    /// is a 10-minute billing interval, so `hours == cellCount / 6`.
    func fetchWorkDiaryHours(contractId: String, date: Date) async throws -> Double {
        struct Resp: Decodable {
            struct WD: Decodable {
                struct Cell: Decodable {}
                let workDiaryTimeCells: [Cell]?
            }
            let workDiaryContract: WD?
        }
        let query = Queries.workDiaryContract(
            contractId: contractId,
            date: Self.compactDateString(date)
        )
        let resp = try await client.execute(query: query, as: Resp.self)
        let cells = resp.workDiaryContract?.workDiaryTimeCells?.count ?? 0
        return Double(cells) / 6.0
    }

    /// Replaces `day`'s time-report rows with `max(report, workDiary)` hours per
    /// contract. Contracts are taken from `timeRows` (the enclosing week), reusing
    /// their title/client/rate. A Work Diary failure for any contract falls back to
    /// the report hours for that contract — never blanks out working data.
    private func augmentWithWorkDiary(
        timeRows: [TimeReportRow],
        day: Date
    ) async -> [TimeReportRow] {
        let contractIds = Set(timeRows.compactMap(\.contractId))
        guard !contractIds.isEmpty else { return timeRows }

        let liveHours: [String: Double] = await withTaskGroup(
            of: (String, Double).self
        ) { group in
            for cid in contractIds {
                group.addTask {
                    let hours = (try? await self.fetchWorkDiaryHours(
                        contractId: cid, date: day)) ?? 0
                    return (cid, hours)
                }
            }
            var result: [String: Double] = [:]
            for await (cid, hours) in group { result[cid] = hours }
            return result
        }

        return Self.overlayWorkDiary(timeRows: timeRows, day: day, liveHours: liveHours)
    }

    /// Pure overlay step: rebuilds `day`'s rows as `max(reportHours, liveHours)`
    /// per contract, carrying each contract's title/client/rate forward from the
    /// surrounding week. Rows on other days pass through unchanged.
    static func overlayWorkDiary(
        timeRows: [TimeReportRow],
        day: Date,
        liveHours: [String: Double]
    ) -> [TimeReportRow] {
        let dayString = DateRange.iso.string(from: day)

        struct Meta {
            var title: String?
            var clientName: String?
            var rate: Double?
            var reportHours: Double
        }
        var metaByContract: [String: Meta] = [:]
        for r in timeRows {
            guard let cid = r.contractId else { continue }
            var m = metaByContract[cid]
                ?? Meta(title: nil, clientName: nil, rate: nil, reportHours: 0)
            m.title = m.title ?? r.contractTitle
            m.clientName = m.clientName ?? r.clientName
            m.rate = m.rate ?? r.hourlyRate
            if r.dateWorkedOn == dayString { m.reportHours += r.hours ?? 0 }
            metaByContract[cid] = m
        }

        var rebuilt = timeRows.filter { $0.dateWorkedOn != dayString }
        for (cid, meta) in metaByContract {
            let hours = max(meta.reportHours, liveHours[cid] ?? 0)
            guard hours > 0 else { continue }
            rebuilt.append(TimeReportRow(
                dateWorkedOn: dayString,
                hours: hours,
                charges: meta.rate.map { $0 * hours } ?? 0,
                contractId: cid,
                contractTitle: meta.title,
                clientName: meta.clientName,
                hourlyRate: meta.rate
            ))
        }
        return rebuilt
    }

    /// Expands `range.start` to the Monday of its Upwork week when the range
    /// covers only one calendar day. Leaves multi-day ranges unchanged.
    private static func weekExpandedRange(for range: DateRange) -> DateRange {
        let cal = Calendar.current
        guard cal.isDate(range.start, inSameDayAs: range.end) else { return range }
        var upworkCal = Calendar(identifier: .gregorian)
        upworkCal.firstWeekday = 2 // Monday
        guard let weekStart = upworkCal.date(
            from: upworkCal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: range.start)
        ), weekStart < range.start else { return range }
        return DateRange(start: weekStart, end: range.end)
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
    /// - Parameter filterDate: When set, only rows whose `dateWorkedOn` falls on
    ///   this day count toward snapshot totals and project breakdown. Daily
    ///   series always includes all returned rows (for sparklines).
    static func merge(
        txRows: [TransactionRow],
        timeRows: [TimeReportRow],
        filterDate: Date? = nil
    ) -> (EarningsSnapshot, [DailyPoint]) {
        let cal = Calendar.current
        let filterDay = filterDate.map { cal.startOfDay(for: $0) }

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

            // When a filterDay is set, only rows on that day count toward the
            // snapshot totals and per-contract breakdown. Rows on other days
            // still populate the daily series used by sparklines/tooltips.
            let rowDay: Date? = r.dateWorkedOn.flatMap { DateRange.iso.date(from: $0) }.map { cal.startOfDay(for: $0) }
            let countsTowardSnapshot = filterDay == nil || rowDay == filterDay

            if countsTowardSnapshot {
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
            }
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
        // Sum across the project list (which already prefers net tx earnings,
        // falling back to gross charges) so the hero/menubar total matches the
        // project rows even when transactions for the period haven't posted yet.
        let totalEarnings = projects.reduce(0) { $0 + $1.earnings }

        let allDays = Set(hoursByDay.keys).union(earningsByDay.keys)
        let daily = allDays
            .map { day -> DailyPoint in
                let earnMap = earningsByDayClient[day] ?? [:]
                let hourMap = hoursByDayClient[day] ?? [:]
                let grossMap = grossByDayClient[day] ?? [:]
                let labels = Set(earnMap.keys).union(hourMap.keys).union(grossMap.keys)
                let breakdown = labels.map { label -> DailyBreakdown in
                    let earnings = earnMap[label] ?? grossMap[label] ?? 0
                    return DailyBreakdown(
                        label: label,
                        earnings: earnings,
                        hours: hourMap[label] ?? 0
                    )
                }
                .sorted { $0.earnings == $1.earnings ? $0.hours > $1.hours : $0.earnings > $1.earnings }
                let dayEarn = breakdown.reduce(0) { $0 + $1.earnings }
                return DailyPoint(
                    date: day,
                    earnings: dayEarn,
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
