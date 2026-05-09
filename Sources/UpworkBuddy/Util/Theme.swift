import SwiftUI

// MARK: - AppTheme

enum AppTheme: String, CaseIterable, Identifiable, Sendable {
    case codeBurn   // original burnt-orange
    case emerald    // Webshare-inspired emerald + deep navy

    var id: String { rawValue }

    var label: String {
        switch self {
        case .codeBurn: return "Code Burn"
        case .emerald:  return "Emerald"
        }
    }

    var palette: ThemePalette {
        switch self {
        case .codeBurn: return .codeBurn
        case .emerald:  return .emerald
        }
    }
}

// MARK: - ThemePalette

struct ThemePalette: Sendable {
    let accent: Color
    let accentDeep: Color
    let accentSoft: Color
    let accentMuted: Color

    let bgTop: Color
    let bgBottom: Color

    let surface: Color
    let chipBg: Color
    let chipActive: Color
    let trackBg: Color
    let divider: Color

    let textPrimary: Color
    let textSecondary: Color
    let textTertiary: Color

    /// Mutable global current palette. SwiftUI views must be invalidated via
    /// `.id(store.appTheme)` on root containers when this changes.
    nonisolated(unsafe) static var current: ThemePalette = .codeBurn
}

extension ThemePalette {
    static let codeBurn = ThemePalette(
        accent:        Color(red: 0.76, green: 0.38, blue: 0.11),
        accentDeep:    Color(red: 0.55, green: 0.23, blue: 0.06),
        accentSoft:    Color(red: 0.84, green: 0.60, blue: 0.42),
        accentMuted:   Color(red: 0.78, green: 0.45, blue: 0.20).opacity(0.18),
        bgTop:         Color(red: 0.93, green: 0.92, blue: 0.90),
        bgBottom:      Color(red: 0.86, green: 0.85, blue: 0.83),
        surface:       Color(red: 0.98, green: 0.97, blue: 0.95),
        chipBg:         Color(red: 0.84, green: 0.82, blue: 0.80),
        chipActive:    Color(red: 0.76, green: 0.38, blue: 0.11),
        trackBg:       Color(red: 0.80, green: 0.78, blue: 0.75),
        divider:       Color(red: 0.79, green: 0.76, blue: 0.72).opacity(0.6),
        textPrimary:   Color(red: 0.11, green: 0.11, blue: 0.11),
        textSecondary: Color(red: 0.38, green: 0.36, blue: 0.34),
        textTertiary:  Color(red: 0.55, green: 0.53, blue: 0.50)
    )

    /// Webshare-inspired: emerald accent, near-white mint background,
    /// deep-navy primary text, cool neutral seconds.
    static let emerald = ThemePalette(
        accent:        Color(red: 0.10, green: 0.70, blue: 0.47),  // #1AB377
        accentDeep:    Color(red: 0.05, green: 0.54, blue: 0.34),  // #0E8A56
        accentSoft:    Color(red: 0.62, green: 0.89, blue: 0.77),  // #9FE3C4
        accentMuted:   Color(red: 0.10, green: 0.70, blue: 0.47).opacity(0.15),
        bgTop:         Color(red: 0.945, green: 0.984, blue: 0.961),  // #F1FBF5
        bgBottom:      Color(red: 0.886, green: 0.949, blue: 0.918),  // #E2F2EA
        surface:       Color(red: 0.980, green: 1.000, blue: 0.988),  // #FAFFFC
        chipBg:        Color(red: 0.859, green: 0.910, blue: 0.882),  // #DBE8E1
        chipActive:    Color(red: 0.10, green: 0.70, blue: 0.47),
        trackBg:       Color(red: 0.812, green: 0.871, blue: 0.835),  // #CFDED5
        divider:       Color(red: 0.706, green: 0.784, blue: 0.745).opacity(0.6),
        textPrimary:   Color(red: 0.055, green: 0.106, blue: 0.173),  // #0E1B2C deep navy
        textSecondary: Color(red: 0.294, green: 0.333, blue: 0.388),  // #4B5563
        textTertiary:  Color(red: 0.561, green: 0.604, blue: 0.639)   // #8F9AA3
    )
}

// MARK: - Theme proxy

/// Static facade that resolves to `ThemePalette.current`. Existing call sites
/// (`Theme.accent`, `Theme.bgGradient`, etc.) continue to work unchanged; views
/// must opt into re-render by binding root `.id(store.appTheme)`.
enum Theme {
    static var accent:        Color { ThemePalette.current.accent }
    static var accentDeep:    Color { ThemePalette.current.accentDeep }
    static var accentSoft:    Color { ThemePalette.current.accentSoft }
    static var accentMuted:   Color { ThemePalette.current.accentMuted }

    static var bgTop:    Color { ThemePalette.current.bgTop }
    static var bgBottom: Color { ThemePalette.current.bgBottom }

    static var surface:    Color { ThemePalette.current.surface }
    static var chipBg:     Color { ThemePalette.current.chipBg }
    static var chipActive: Color { ThemePalette.current.chipActive }
    static var trackBg:    Color { ThemePalette.current.trackBg }
    static var divider:    Color { ThemePalette.current.divider }

    static var textPrimary:   Color { ThemePalette.current.textPrimary }
    static var textSecondary: Color { ThemePalette.current.textSecondary }
    static var textTertiary:  Color { ThemePalette.current.textTertiary }

    static var bgGradient: LinearGradient {
        LinearGradient(colors: [bgTop, bgBottom], startPoint: .top, endPoint: .bottom)
    }
}

struct SectionDotLabel: View {
    let title: String
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(Theme.accent).frame(width: 5, height: 5)
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
        }
    }
}
