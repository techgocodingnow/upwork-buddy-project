import Foundation

/// Per-(tenant, range) snapshot cache with TTL. `actor` so concurrent readers/writers
/// can't race and so we can dedupe in-flight loaders.
actor ReportCache {
    static let shared = ReportCache()

    struct Key: Hashable {
        let tenantId: String
        let rangeStart: String
        let rangeEnd: String
        var projectNameStyle: ProjectNameStyle = .projectTitle
    }

    struct Entry {
        let snapshot: EarningsSnapshot
        let daily: [DailyPoint]
        let storedAt: Date
    }

    private var entries: [Key: Entry] = [:]
    private var ttl: TimeInterval = 300 // 5 minutes
    private let clock: DateProvider

    init(clock: DateProvider = SystemDateProvider()) {
        self.clock = clock
    }

    func setTTL(_ seconds: TimeInterval) { ttl = seconds }

    func get(_ key: Key, force: Bool = false) -> Entry? {
        guard let entry = entries[key], !force else { return nil }
        guard clock.now().timeIntervalSince(entry.storedAt) < ttl else { return nil }
        return entry
    }

    func set(_ key: Key, snapshot: EarningsSnapshot, daily: [DailyPoint]) {
        entries[key] = Entry(snapshot: snapshot, daily: daily, storedAt: clock.now())
    }

    func clear() { entries.removeAll() }
}
