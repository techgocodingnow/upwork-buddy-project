import Testing
import Foundation
@testable import UpworkBuddy

@Suite("ReportCache (clock-driven)")
struct ReportCacheClockTests {

    private func makeKey() -> ReportCache.Key {
        ReportCache.Key(tenantId: "t1", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
    }

    @Test func returnsEntryBeforeTTL() async {
        let clock = MockDateProvider()
        let cache = ReportCache(clock: clock)
        await cache.setTTL(60)
        await cache.set(makeKey(), snapshot: .empty, daily: [])

        clock.advance(by: 30)
        let entry = await cache.get(makeKey())
        #expect(entry != nil)
    }

    @Test func returnsNilAtTTLBoundary() async {
        let clock = MockDateProvider()
        let cache = ReportCache(clock: clock)
        await cache.setTTL(60)
        await cache.set(makeKey(), snapshot: .empty, daily: [])

        // TTL check is strict `<` — at exactly TTL, considered expired.
        clock.advance(by: 60)
        let entry = await cache.get(makeKey())
        #expect(entry == nil)
    }

    @Test func returnsNilWellPastTTL() async {
        let clock = MockDateProvider()
        let cache = ReportCache(clock: clock)
        await cache.setTTL(60)
        await cache.set(makeKey(), snapshot: .empty, daily: [])

        clock.advance(by: 3600)
        let entry = await cache.get(makeKey())
        #expect(entry == nil)
    }

    @Test func setRefreshesStoredAtBasedOnClockNow() async {
        let clock = MockDateProvider()
        let cache = ReportCache(clock: clock)
        await cache.setTTL(60)

        await cache.set(makeKey(), snapshot: .empty, daily: [])
        clock.advance(by: 50)
        // Re-set near expiry: storedAt resets, so 30s later still in TTL.
        await cache.set(makeKey(), snapshot: .empty, daily: [])
        clock.advance(by: 30)
        let entry = await cache.get(makeKey())
        #expect(entry != nil)
    }

    @Test func forceBypassesEvenInsideTTL() async {
        let clock = MockDateProvider()
        let cache = ReportCache(clock: clock)
        await cache.set(makeKey(), snapshot: .empty, daily: [])
        clock.advance(by: 1)
        let entry = await cache.get(makeKey(), force: true)
        #expect(entry == nil)
    }

    @Test func clearRemovesAllEntries() async {
        let clock = MockDateProvider()
        let cache = ReportCache(clock: clock)
        let k1 = ReportCache.Key(tenantId: "t1", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
        let k2 = ReportCache.Key(tenantId: "t2", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
        await cache.set(k1, snapshot: .empty, daily: [])
        await cache.set(k2, snapshot: .empty, daily: [])
        await cache.clear()
        #expect(await cache.get(k1) == nil)
        #expect(await cache.get(k2) == nil)
    }

    @Test func differentTenantsKeptSeparate() async {
        let clock = MockDateProvider()
        let cache = ReportCache(clock: clock)
        let k1 = ReportCache.Key(tenantId: "t1", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
        let k2 = ReportCache.Key(tenantId: "t2", rangeStart: "2026-05-01", rangeEnd: "2026-05-04")
        await cache.set(k1, snapshot: .empty, daily: [])
        #expect(await cache.get(k2) == nil)
        #expect(await cache.get(k1) != nil)
    }
}
