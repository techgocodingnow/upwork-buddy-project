import XCTest
@testable import UpworkBuddy

final class ReportCacheTests: XCTestCase {
    func testReturnsNilWhenEmpty() async {
        let cache = ReportCache()
        let key = ReportCache.Key(tenantId: "t1", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
        let result = await cache.get(key)
        XCTAssertNil(result)
    }

    func testReturnsCachedEntryWithinTTL() async {
        let cache = ReportCache()
        let key = ReportCache.Key(tenantId: "t1", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
        await cache.set(key, snapshot: .empty, daily: [])
        let entry = await cache.get(key)
        XCTAssertNotNil(entry)
    }

    func testStoresPreviousSnapshot() async {
        let cache = ReportCache()
        let key = ReportCache.Key(tenantId: "t1", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
        let previous = EarningsSnapshot(totalHours: 3, totalEarnings: 120, projects: [], generatedAt: Date())
        await cache.set(key, snapshot: .empty, daily: [], previous: previous)
        let entry = await cache.get(key)
        XCTAssertEqual(entry?.previous.totalHours, 3)
        XCTAssertEqual(entry?.previous.totalEarnings, 120)
    }

    func testForceBypassesCache() async {
        let cache = ReportCache()
        let key = ReportCache.Key(tenantId: "t1", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
        await cache.set(key, snapshot: .empty, daily: [])
        let entry = await cache.get(key, force: true)
        XCTAssertNil(entry)
    }

    func testExpiresAfterTTL() async {
        let cache = ReportCache()
        await cache.setTTL(0.05)
        let key = ReportCache.Key(tenantId: "t1", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
        await cache.set(key, snapshot: .empty, daily: [])
        try? await Task.sleep(nanoseconds: 100_000_000)
        let entry = await cache.get(key)
        XCTAssertNil(entry)
    }
}
