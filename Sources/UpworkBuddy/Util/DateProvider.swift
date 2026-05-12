import Foundation

/// Indirection over `Date()` so time-dependent code (TTL caches, threshold
/// crossing detectors) can be driven by a fake clock in tests. Named
/// `DateProvider` to avoid collision with Swift stdlib's `Clock` protocol.
protocol DateProvider: Sendable {
    func now() -> Date
}

struct SystemDateProvider: DateProvider {
    func now() -> Date { Date() }
}
