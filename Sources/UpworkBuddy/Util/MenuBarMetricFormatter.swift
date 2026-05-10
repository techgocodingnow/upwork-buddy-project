import Foundation

/// Resolves the visible label for a menu-bar metric — shared by settings preview
/// and the live status item. Honors the user's display mode (percentage vs count
/// vs goal) and the period's hours/earnings goal targets.
@MainActor
enum MenuBarMetricFormatter {
    /// Numeric progress 0...1+ against the period's goal target. Falls back to
    /// hours target, then earnings, then 0 when no goal is set.
    static func progress(snapshot: EarningsSnapshot,
                         period: Period,
                         store: AppStore) -> Double {
        let hoursTarget = store.goalTarget(for: .hours, period: period)
        if hoursTarget > 0 { return snapshot.totalHours / hoursTarget }
        let earnTarget = store.goalTarget(for: .earnings, period: period)
        if earnTarget > 0 { return snapshot.totalEarnings / earnTarget }
        return 0
    }

    /// Visible text rendered next to / inside the icon. Empty string when no
    /// data is meaningful (e.g. no goal and count mode requested).
    static func label(snapshot: EarningsSnapshot,
                      period: Period,
                      store: AppStore,
                      mode: MenuBarDisplayMode) -> String {
        let hoursTarget = store.goalTarget(for: .hours, period: period)
        let earnTarget = store.goalTarget(for: .earnings, period: period)

        switch mode {
        case .percentage:
            let pct = progress(snapshot: snapshot, period: period, store: store)
            if pct == 0 { return "—" }
            let intPct = max(0, min(999, Int((pct * 100).rounded())))
            return "\(intPct)%"

        case .count:
            if hoursTarget > 0 {
                let cur = formatHours(snapshot.totalHours)
                let tgt = formatHours(hoursTarget)
                return "\(cur)/\(tgt)"
            }
            if earnTarget > 0 {
                let f = CurrencyFormat(code: store.currency, masked: store.hideSensitive)
                return "\(f.compact(snapshot.totalEarnings))/\(f.compact(earnTarget))"
            }
            // No goal set — render the raw value as a graceful fallback.
            if snapshot.totalHours > 0 { return formatHours(snapshot.totalHours) }
            let f = CurrencyFormat(code: store.currency, masked: store.hideSensitive)
            return f.compact(snapshot.totalEarnings)
        }
    }

    private static func formatHours(_ hours: Double) -> String {
        if hours <= 0 { return "0h" }
        let whole = Int(hours)
        let frac = hours - Double(whole)
        if frac < 0.05 { return "\(whole)h" }
        return String(format: "%.1fh", hours)
    }
}
