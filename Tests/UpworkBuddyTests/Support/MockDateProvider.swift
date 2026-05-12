import Foundation
@testable import UpworkBuddy

/// Test double for `DateProvider` — advance time without `Task.sleep`.
final class MockDateProvider: DateProvider, @unchecked Sendable {
    private let lock = NSLock()
    private var current: Date

    init(_ start: Date = Date(timeIntervalSince1970: 1_700_000_000)) {
        self.current = start
    }

    func now() -> Date {
        lock.lock(); defer { lock.unlock() }
        return current
    }

    func advance(by seconds: TimeInterval) {
        lock.lock(); defer { lock.unlock() }
        current = current.addingTimeInterval(seconds)
    }

    func set(_ date: Date) {
        lock.lock(); defer { lock.unlock() }
        current = date
    }
}
