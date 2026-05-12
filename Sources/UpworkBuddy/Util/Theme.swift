import SwiftUI

// MARK: - AppTheme

enum AppTheme: String, CaseIterable, Identifiable, Sendable {
    case codeBurn   // burnt-orange
    case emerald    // Webshare-inspired emerald + deep navy
    case midnight   // Linear-inspired tech blue
    case brutalist  // Neo-brutalism: high-contrast black + yellow
    case sunset     // Warm peach → magenta
    case forest     // Deep green + amber luxury
    case terminal   // Phosphor CRT — green-on-black hacker shell
    case vaporwave  // Neon magenta + cyan on deep purple void
    case sketch     // Pencil + paper + correction-marker red
    case minimalDark // Layered slate + warm amber, atmospheric glass
    case playful    // Violet + hot pink + amber + mint confetti
    case cyberpunk  // Matrix green + magenta + electric blue on void
    case kinetic    // Acid yellow on rich black, ultra-bold motion editorial
    case artDeco    // Gold + midnight blue on obsidian, geometric luxury

    var id: String { rawValue }

    var label: String {
        switch self {
        case .codeBurn:  return L10n.t("Code Burn")
        case .emerald:   return L10n.t("Emerald")
        case .midnight:  return L10n.t("Midnight")
        case .brutalist: return L10n.t("Neo Brutalism")
        case .sunset:    return L10n.t("Sunset")
        case .forest:    return L10n.t("Forest")
        case .terminal:  return L10n.t("Terminal")
        case .vaporwave: return L10n.t("Vaporwave")
        case .sketch:    return L10n.t("Sketch")
        case .minimalDark: return L10n.t("Minimal Dark")
        case .playful:   return L10n.t("Playful")
        case .cyberpunk: return L10n.t("Cyberpunk")
        case .kinetic:   return L10n.t("Kinetic")
        case .artDeco:   return L10n.t("Art Deco")
        }
    }

    /// Resolve palette for a given system color scheme.
    func palette(for scheme: ColorScheme) -> ThemePalette {
        switch (self, scheme) {
        case (.codeBurn,  .light): return .codeBurnLight
        case (.codeBurn,  .dark):  return .codeBurnDark
        case (.emerald,   .light): return .emeraldLight
        case (.emerald,   .dark):  return .emeraldDark
        case (.midnight,  .light): return .midnightLight
        case (.midnight,  .dark):  return .midnightDark
        case (.brutalist, .light): return .brutalistLight
        case (.brutalist, .dark):  return .brutalistDark
        case (.sunset,    .light): return .sunsetLight
        case (.sunset,    .dark):  return .sunsetDark
        case (.forest,    .light): return .forestLight
        case (.forest,    .dark):  return .forestDark
        case (.terminal,  .light): return .terminalLight
        case (.terminal,  .dark):  return .terminalDark
        case (.vaporwave, .light): return .vaporwaveLight
        case (.vaporwave, .dark):  return .vaporwaveDark
        case (.sketch,    .light): return .sketchLight
        case (.sketch,    .dark):  return .sketchDark
        case (.minimalDark, .light): return .minimalDarkLight
        case (.minimalDark, .dark):  return .minimalDarkDark
        case (.playful,   .light): return .playfulLight
        case (.playful,   .dark):  return .playfulDark
        case (.cyberpunk, .light): return .cyberpunkLight
        case (.cyberpunk, .dark):  return .cyberpunkDark
        case (.kinetic,   .light): return .kineticLight
        case (.kinetic,   .dark):  return .kineticDark
        case (.artDeco,   .light): return .artDecoLight
        case (.artDeco,   .dark):  return .artDecoDark
        @unknown default:          return .codeBurnLight
        }
    }
}

// MARK: - AppAppearance

/// User-controlled appearance override. `.system` follows macOS; the others
/// force light/dark regardless of system setting.
enum AppAppearance: String, CaseIterable, Identifiable, Sendable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return L10n.t("System")
        case .light:  return L10n.t("Light")
        case .dark:   return L10n.t("Dark")
        }
    }

    var systemImage: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light:  return "sun.max"
        case .dark:   return "moon"
        }
    }

    /// Returns `nil` to follow system, else forces a specific scheme.
    var preferredColorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
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

    /// Multiplier applied to default corner radii. `1.0` is normal; `0.0`
    /// gives brutalist hard edges. Used by themed shape helpers.
    let cornerRadiusScale: CGFloat

    /// Foreground color guaranteed to contrast against `accent` / `accentDeep`
    /// (used for filled accent buttons and logo glyphs).
    let onAccent: Color

    /// If true, components should bias toward monospaced typography
    /// (Terminal, certain code-centric themes). Only affects text styling,
    /// not numerics that are already explicitly monospaced.
    let usesMonospace: Bool

    /// Mutable global current palette. Resolved by `ThemedRoot` from
    /// (`AppTheme`, `ColorScheme`). Views opt into refresh via the same
    /// `ThemedRoot` modifier that sets it.
    nonisolated(unsafe) static var current: ThemePalette = .codeBurnLight

    init(
        accent: Color,
        accentDeep: Color,
        accentSoft: Color,
        accentMuted: Color,
        bgTop: Color,
        bgBottom: Color,
        surface: Color,
        chipBg: Color,
        chipActive: Color,
        trackBg: Color,
        divider: Color,
        textPrimary: Color,
        textSecondary: Color,
        textTertiary: Color,
        cornerRadiusScale: CGFloat = 1.0,
        onAccent: Color = .white,
        usesMonospace: Bool = false
    ) {
        self.accent = accent
        self.accentDeep = accentDeep
        self.accentSoft = accentSoft
        self.accentMuted = accentMuted
        self.bgTop = bgTop
        self.bgBottom = bgBottom
        self.surface = surface
        self.chipBg = chipBg
        self.chipActive = chipActive
        self.trackBg = trackBg
        self.divider = divider
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.cornerRadiusScale = cornerRadiusScale
        self.onAccent = onAccent
        self.usesMonospace = usesMonospace
    }
}

extension ThemePalette {
    // MARK: codeBurn — light

    static let codeBurnLight = ThemePalette(
        accent:        Color(red: 0.76, green: 0.38, blue: 0.11),
        accentDeep:    Color(red: 0.55, green: 0.23, blue: 0.06),
        accentSoft:    Color(red: 0.84, green: 0.60, blue: 0.42),
        accentMuted:   Color(red: 0.78, green: 0.45, blue: 0.20).opacity(0.18),
        bgTop:         Color(red: 0.93, green: 0.92, blue: 0.90),
        bgBottom:      Color(red: 0.86, green: 0.85, blue: 0.83),
        surface:       Color(red: 0.98, green: 0.97, blue: 0.95),
        chipBg:        Color(red: 0.84, green: 0.82, blue: 0.80),
        chipActive:    Color(red: 0.76, green: 0.38, blue: 0.11),
        trackBg:       Color(red: 0.80, green: 0.78, blue: 0.75),
        divider:       Color(red: 0.79, green: 0.76, blue: 0.72).opacity(0.6),
        textPrimary:   Color(red: 0.11, green: 0.11, blue: 0.11),
        textSecondary: Color(red: 0.32, green: 0.30, blue: 0.28),
        textTertiary:  Color(red: 0.45, green: 0.42, blue: 0.39)
    )

    // MARK: codeBurn — dark
    // Warmer accent for visibility on dark; deep neutrals from charcoal/espresso.
    static let codeBurnDark = ThemePalette(
        accent:        Color(red: 0.95, green: 0.55, blue: 0.22),   // #F28D38
        accentDeep:    Color(red: 1.00, green: 0.70, blue: 0.42),   // brighter for dark contrast
        accentSoft:    Color(red: 0.65, green: 0.42, blue: 0.25),
        accentMuted:   Color(red: 0.95, green: 0.55, blue: 0.22).opacity(0.22),
        bgTop:         Color(red: 0.10, green: 0.09, blue: 0.085),  // #1A1716
        bgBottom:      Color(red: 0.07, green: 0.065, blue: 0.06),  // #11100F
        surface:       Color(red: 0.14, green: 0.13, blue: 0.12),   // #242220
        chipBg:        Color(red: 0.20, green: 0.18, blue: 0.16),
        chipActive:    Color(red: 0.95, green: 0.55, blue: 0.22),
        trackBg:       Color(red: 0.22, green: 0.20, blue: 0.18),
        divider:       Color(red: 0.30, green: 0.27, blue: 0.24).opacity(0.6),
        textPrimary:   Color(red: 0.96, green: 0.95, blue: 0.93),
        textSecondary: Color(red: 0.78, green: 0.75, blue: 0.71),
        textTertiary:  Color(red: 0.60, green: 0.57, blue: 0.53)
    )

    // MARK: emerald — light

    static let emeraldLight = ThemePalette(
        accent:        Color(red: 0.10, green: 0.70, blue: 0.47),   // #1AB377
        accentDeep:    Color(red: 0.043, green: 0.478, blue: 0.290), // #0B7A4A
        accentSoft:    Color(red: 0.62, green: 0.89, blue: 0.77),
        accentMuted:   Color(red: 0.10, green: 0.70, blue: 0.47).opacity(0.15),
        bgTop:         Color(red: 0.945, green: 0.984, blue: 0.961),
        bgBottom:      Color(red: 0.886, green: 0.949, blue: 0.918),
        surface:       Color(red: 0.980, green: 1.000, blue: 0.988),
        chipBg:        Color(red: 0.859, green: 0.910, blue: 0.882),
        chipActive:    Color(red: 0.10, green: 0.70, blue: 0.47),
        trackBg:       Color(red: 0.812, green: 0.871, blue: 0.835),
        divider:       Color(red: 0.706, green: 0.784, blue: 0.745).opacity(0.6),
        textPrimary:   Color(red: 0.055, green: 0.106, blue: 0.173),
        textSecondary: Color(red: 0.235, green: 0.275, blue: 0.329),
        textTertiary:  Color(red: 0.361, green: 0.408, blue: 0.471)
    )

    // MARK: emerald — dark

    static let emeraldDark = ThemePalette(
        accent:        Color(red: 0.20, green: 0.82, blue: 0.55),   // brighter emerald
        accentDeep:    Color(red: 0.40, green: 0.92, blue: 0.68),   // light on dark
        accentSoft:    Color(red: 0.18, green: 0.45, blue: 0.34),
        accentMuted:   Color(red: 0.20, green: 0.82, blue: 0.55).opacity(0.20),
        bgTop:         Color(red: 0.055, green: 0.090, blue: 0.075), // #0E1713
        bgBottom:      Color(red: 0.035, green: 0.063, blue: 0.051), // #091010
        surface:       Color(red: 0.082, green: 0.122, blue: 0.106), // #15201B
        chipBg:        Color(red: 0.118, green: 0.169, blue: 0.149), // #1E2B26
        chipActive:    Color(red: 0.20, green: 0.82, blue: 0.55),
        trackBg:       Color(red: 0.149, green: 0.208, blue: 0.184),
        divider:       Color(red: 0.243, green: 0.314, blue: 0.282).opacity(0.6),
        textPrimary:   Color(red: 0.945, green: 0.973, blue: 0.957),
        textSecondary: Color(red: 0.737, green: 0.792, blue: 0.769),
        textTertiary:  Color(red: 0.541, green: 0.604, blue: 0.580)
    )

    // MARK: midnight — light (Linear-inspired tech blue)

    static let midnightLight = ThemePalette(
        accent:        Color(red: 0.231, green: 0.431, blue: 0.965), // #3B6EF6
        accentDeep:    Color(red: 0.149, green: 0.318, blue: 0.804), // #2651CD
        accentSoft:    Color(red: 0.616, green: 0.706, blue: 0.984),
        accentMuted:   Color(red: 0.231, green: 0.431, blue: 0.965).opacity(0.14),
        bgTop:         Color(red: 0.969, green: 0.973, blue: 0.984), // #F7F8FB
        bgBottom:      Color(red: 0.929, green: 0.937, blue: 0.957), // #EDEFF4
        surface:       Color(red: 1.000, green: 1.000, blue: 1.000),
        chipBg:        Color(red: 0.902, green: 0.914, blue: 0.945),
        chipActive:    Color(red: 0.231, green: 0.431, blue: 0.965),
        trackBg:       Color(red: 0.871, green: 0.886, blue: 0.918),
        divider:       Color(red: 0.808, green: 0.831, blue: 0.875).opacity(0.7),
        textPrimary:   Color(red: 0.067, green: 0.094, blue: 0.157), // #111828
        textSecondary: Color(red: 0.290, green: 0.337, blue: 0.420),
        textTertiary:  Color(red: 0.443, green: 0.490, blue: 0.569)
    )

    // MARK: midnight — dark

    static let midnightDark = ThemePalette(
        accent:        Color(red: 0.486, green: 0.643, blue: 1.000), // #7CA4FF
        accentDeep:    Color(red: 0.671, green: 0.776, blue: 1.000),
        accentSoft:    Color(red: 0.220, green: 0.310, blue: 0.541),
        accentMuted:   Color(red: 0.486, green: 0.643, blue: 1.000).opacity(0.18),
        bgTop:         Color(red: 0.043, green: 0.055, blue: 0.094), // #0B0E18
        bgBottom:      Color(red: 0.027, green: 0.035, blue: 0.063), // #07090F
        surface:       Color(red: 0.071, green: 0.090, blue: 0.137), // #12172A
        chipBg:        Color(red: 0.106, green: 0.129, blue: 0.196),
        chipActive:    Color(red: 0.486, green: 0.643, blue: 1.000),
        trackBg:       Color(red: 0.137, green: 0.165, blue: 0.243),
        divider:       Color(red: 0.231, green: 0.275, blue: 0.357).opacity(0.6),
        textPrimary:   Color(red: 0.949, green: 0.961, blue: 0.984),
        textSecondary: Color(red: 0.722, green: 0.757, blue: 0.831),
        textTertiary:  Color(red: 0.529, green: 0.573, blue: 0.659)
    )

    // MARK: brutalist — light (canonical Neo-Brutalism cream + ink + pop)
    // Palette from docs/themes/neo-brutalism.md: cream canvas, pure black ink,
    // hot-red primary, vivid yellow secondary, soft-violet muted.

    static let brutalistLight = ThemePalette(
        accent:        Color(red: 1.000, green: 0.420, blue: 0.420), // #FF6B6B hot red
        accentDeep:    Color(red: 0.000, green: 0.000, blue: 0.000), // black ink
        accentSoft:    Color(red: 1.000, green: 0.851, blue: 0.239), // #FFD93D vivid yellow
        accentMuted:   Color(red: 0.769, green: 0.710, blue: 0.992), // #C4B5FD soft violet
        bgTop:         Color(red: 1.000, green: 0.992, blue: 0.961), // #FFFDF5 cream
        bgBottom:      Color(red: 0.976, green: 0.965, blue: 0.929),
        surface:       Color(red: 1.000, green: 1.000, blue: 1.000), // contrast panel white
        chipBg:        Color(red: 1.000, green: 0.851, blue: 0.239), // yellow chip
        chipActive:    Color(red: 1.000, green: 0.420, blue: 0.420),
        trackBg:       Color(red: 0.898, green: 0.890, blue: 0.847),
        divider:       Color(red: 0.000, green: 0.000, blue: 0.000), // hard black
        textPrimary:   Color(red: 0.000, green: 0.000, blue: 0.000),
        textSecondary: Color(red: 0.118, green: 0.118, blue: 0.118),
        textTertiary:  Color(red: 0.298, green: 0.298, blue: 0.298),
        cornerRadiusScale: 0.0,
        onAccent:      Color.white                                    // white on hot red
    )

    // MARK: brutalist — dark (inverted: black canvas, pop colors hold)
    // Dark variant inverts canvas so the same hot-red/yellow/violet pops
    // remain identifiable when user forces dark appearance.

    static let brutalistDark = ThemePalette(
        accent:        Color(red: 1.000, green: 0.502, blue: 0.502), // brighter red
        accentDeep:    Color(red: 1.000, green: 1.000, blue: 1.000), // white ink
        accentSoft:    Color(red: 1.000, green: 0.882, blue: 0.349),
        accentMuted:   Color(red: 0.804, green: 0.745, blue: 1.000), // brighter violet
        bgTop:         Color(red: 0.043, green: 0.043, blue: 0.043), // #0B0B0B
        bgBottom:      Color(red: 0.000, green: 0.000, blue: 0.000),
        surface:       Color(red: 0.071, green: 0.071, blue: 0.071),
        chipBg:        Color(red: 1.000, green: 0.882, blue: 0.349),
        chipActive:    Color(red: 1.000, green: 0.502, blue: 0.502),
        trackBg:       Color(red: 0.157, green: 0.157, blue: 0.157),
        divider:       Color.white,
        textPrimary:   Color.white,
        textSecondary: Color(red: 0.882, green: 0.882, blue: 0.882),
        textTertiary:  Color(red: 0.706, green: 0.706, blue: 0.706),
        cornerRadiusScale: 0.0,
        onAccent:      Color.white
    )

    // MARK: sunset — light (warm peach → magenta)

    static let sunsetLight = ThemePalette(
        accent:        Color(red: 1.000, green: 0.420, blue: 0.420), // #FF6B6B
        accentDeep:    Color(red: 0.831, green: 0.220, blue: 0.310), // #D43850
        accentSoft:    Color(red: 1.000, green: 0.733, blue: 0.671), // peach
        accentMuted:   Color(red: 1.000, green: 0.420, blue: 0.420).opacity(0.16),
        bgTop:         Color(red: 1.000, green: 0.965, blue: 0.949), // #FFF6F2
        bgBottom:      Color(red: 0.992, green: 0.918, blue: 0.910), // #FDEAE8
        surface:       Color(red: 1.000, green: 0.984, blue: 0.976),
        chipBg:        Color(red: 0.984, green: 0.886, blue: 0.875),
        chipActive:    Color(red: 1.000, green: 0.420, blue: 0.420),
        trackBg:       Color(red: 0.969, green: 0.847, blue: 0.831),
        divider:       Color(red: 0.910, green: 0.788, blue: 0.776).opacity(0.7),
        textPrimary:   Color(red: 0.235, green: 0.106, blue: 0.137), // deep wine
        textSecondary: Color(red: 0.420, green: 0.243, blue: 0.275),
        textTertiary:  Color(red: 0.561, green: 0.388, blue: 0.412)
    )

    // MARK: sunset — dark

    static let sunsetDark = ThemePalette(
        accent:        Color(red: 1.000, green: 0.557, blue: 0.557), // #FF8E8E
        accentDeep:    Color(red: 1.000, green: 0.722, blue: 0.671),
        accentSoft:    Color(red: 0.498, green: 0.227, blue: 0.286),
        accentMuted:   Color(red: 1.000, green: 0.557, blue: 0.557).opacity(0.22),
        bgTop:         Color(red: 0.122, green: 0.063, blue: 0.082), // #1F1015
        bgBottom:      Color(red: 0.082, green: 0.039, blue: 0.055),
        surface:       Color(red: 0.165, green: 0.094, blue: 0.118),
        chipBg:        Color(red: 0.220, green: 0.122, blue: 0.149),
        chipActive:    Color(red: 1.000, green: 0.557, blue: 0.557),
        trackBg:       Color(red: 0.251, green: 0.149, blue: 0.176),
        divider:       Color(red: 0.349, green: 0.220, blue: 0.255).opacity(0.6),
        textPrimary:   Color(red: 0.992, green: 0.945, blue: 0.945),
        textSecondary: Color(red: 0.831, green: 0.733, blue: 0.749),
        textTertiary:  Color(red: 0.616, green: 0.510, blue: 0.541)
    )

    // MARK: forest — light (deep green + amber)

    static let forestLight = ThemePalette(
        accent:        Color(red: 0.184, green: 0.420, blue: 0.271), // #2F6B45
        accentDeep:    Color(red: 0.114, green: 0.298, blue: 0.184), // #1D4C2F
        accentSoft:    Color(red: 0.890, green: 0.671, blue: 0.298), // amber
        accentMuted:   Color(red: 0.184, green: 0.420, blue: 0.271).opacity(0.14),
        bgTop:         Color(red: 0.961, green: 0.957, blue: 0.929), // warm cream
        bgBottom:      Color(red: 0.925, green: 0.910, blue: 0.871),
        surface:       Color(red: 0.984, green: 0.980, blue: 0.957),
        chipBg:        Color(red: 0.886, green: 0.871, blue: 0.831),
        chipActive:    Color(red: 0.184, green: 0.420, blue: 0.271),
        trackBg:       Color(red: 0.847, green: 0.831, blue: 0.788),
        divider:       Color(red: 0.788, green: 0.769, blue: 0.722).opacity(0.7),
        textPrimary:   Color(red: 0.106, green: 0.137, blue: 0.106), // forest ink
        textSecondary: Color(red: 0.275, green: 0.298, blue: 0.255),
        textTertiary:  Color(red: 0.420, green: 0.439, blue: 0.388)
    )

    // MARK: forest — dark

    static let forestDark = ThemePalette(
        accent:        Color(red: 0.482, green: 0.773, blue: 0.596), // #7BC598
        accentDeep:    Color(red: 0.624, green: 0.851, blue: 0.706),
        accentSoft:    Color(red: 0.961, green: 0.776, blue: 0.435), // amber pop
        accentMuted:   Color(red: 0.482, green: 0.773, blue: 0.596).opacity(0.20),
        bgTop:         Color(red: 0.039, green: 0.082, blue: 0.055), // deep moss
        bgBottom:      Color(red: 0.024, green: 0.055, blue: 0.039),
        surface:       Color(red: 0.063, green: 0.114, blue: 0.082),
        chipBg:        Color(red: 0.094, green: 0.157, blue: 0.114),
        chipActive:    Color(red: 0.482, green: 0.773, blue: 0.596),
        trackBg:       Color(red: 0.118, green: 0.192, blue: 0.141),
        divider:       Color(red: 0.196, green: 0.286, blue: 0.227).opacity(0.6),
        textPrimary:   Color(red: 0.949, green: 0.965, blue: 0.949),
        textSecondary: Color(red: 0.745, green: 0.788, blue: 0.745),
        textTertiary:  Color(red: 0.545, green: 0.604, blue: 0.553)
    )

    // MARK: terminal — dark (canonical phosphor CRT)
    // Palette from docs/themes/terminal.md: deep black bg, neon green
    // foreground, amber secondary, dimmed-green borders. Hard 1px edges.

    static let terminalDark = ThemePalette(
        accent:        Color(red: 0.200, green: 1.000, blue: 0.000), // #33FF00 phosphor green
        accentDeep:    Color(red: 0.200, green: 1.000, blue: 0.000), // primary doubles as deep
        accentSoft:    Color(red: 1.000, green: 0.690, blue: 0.000), // #FFB000 amber secondary
        accentMuted:   Color(red: 0.200, green: 1.000, blue: 0.000).opacity(0.18),
        bgTop:         Color(red: 0.039, green: 0.039, blue: 0.039), // #0A0A0A
        bgBottom:      Color(red: 0.020, green: 0.020, blue: 0.020),
        surface:       Color(red: 0.039, green: 0.039, blue: 0.039), // surfaces are bg+border
        chipBg:        Color(red: 0.078, green: 0.157, blue: 0.078), // dim green wash
        chipActive:    Color(red: 0.200, green: 1.000, blue: 0.000),
        trackBg:       Color(red: 0.122, green: 0.322, blue: 0.122), // #1F521F muted
        divider:       Color(red: 0.122, green: 0.322, blue: 0.122), // 1px solid green
        textPrimary:   Color(red: 0.200, green: 1.000, blue: 0.000), // foreground = green
        textSecondary: Color(red: 0.400, green: 0.800, blue: 0.400),
        textTertiary:  Color(red: 0.290, green: 0.541, blue: 0.290),
        cornerRadiusScale: 0.0,
        onAccent:      Color(red: 0.020, green: 0.020, blue: 0.020), // black on green pill
        usesMonospace: true
    )

    // MARK: terminal — light (inverted "paper printout")
    // Light mode is non-canonical for Terminal, but the app supports light
    // override globally — keep the same vocabulary (mono, sharp corners,
    // green ink) on an off-white printout background so the theme stays
    // legible when the user forces appearance=.light.

    static let terminalLight = ThemePalette(
        accent:        Color(red: 0.000, green: 0.471, blue: 0.122), // #007820 deep green ink
        accentDeep:    Color(red: 0.000, green: 0.353, blue: 0.090), // #005A17
        accentSoft:    Color(red: 0.612, green: 0.396, blue: 0.000), // amber ink
        accentMuted:   Color(red: 0.000, green: 0.471, blue: 0.122).opacity(0.12),
        bgTop:         Color(red: 0.957, green: 0.953, blue: 0.929), // off-white paper #F4F3ED
        bgBottom:      Color(red: 0.929, green: 0.922, blue: 0.890), // #EDEBE3
        surface:       Color(red: 0.969, green: 0.965, blue: 0.945),
        chipBg:        Color(red: 0.871, green: 0.910, blue: 0.871),
        chipActive:    Color(red: 0.000, green: 0.471, blue: 0.122),
        trackBg:       Color(red: 0.788, green: 0.847, blue: 0.788),
        divider:       Color(red: 0.000, green: 0.471, blue: 0.122).opacity(0.55),
        textPrimary:   Color(red: 0.000, green: 0.353, blue: 0.090),
        textSecondary: Color(red: 0.094, green: 0.286, blue: 0.122),
        textTertiary:  Color(red: 0.290, green: 0.412, blue: 0.290),
        cornerRadiusScale: 0.0,
        onAccent:      Color(red: 0.957, green: 0.953, blue: 0.929), // paper on ink
        usesMonospace: true
    )

    // MARK: vaporwave — dark (canonical neon void)
    // Palette from docs/themes/vaporwave.md: deep purple/black void, hot
    // magenta hero, electric cyan secondary, sunset orange tertiary.
    // Aggressively geometric: 0 corner radius, mono UI font.

    static let vaporwaveDark = ThemePalette(
        accent:        Color(red: 1.000, green: 0.000, blue: 1.000), // #FF00FF magenta
        accentDeep:    Color(red: 0.000, green: 1.000, blue: 1.000), // #00FFFF cyan
        accentSoft:    Color(red: 1.000, green: 0.600, blue: 0.000), // #FF9900 sunset
        accentMuted:   Color(red: 1.000, green: 0.000, blue: 1.000).opacity(0.20),
        bgTop:         Color(red: 0.035, green: 0.000, blue: 0.078), // #090014 void
        bgBottom:      Color(red: 0.020, green: 0.000, blue: 0.043),
        surface:       Color(red: 0.102, green: 0.063, blue: 0.235), // #1A103C glass panel
        chipBg:        Color(red: 0.176, green: 0.106, blue: 0.306), // #2D1B4E
        chipActive:    Color(red: 1.000, green: 0.000, blue: 1.000),
        trackBg:       Color(red: 0.137, green: 0.078, blue: 0.275),
        divider:       Color(red: 0.176, green: 0.106, blue: 0.306),
        textPrimary:   Color(red: 0.878, green: 0.878, blue: 0.878), // #E0E0E0 chrome
        textSecondary: Color(red: 0.000, green: 1.000, blue: 1.000).opacity(0.85), // cyan-tinted
        textTertiary:  Color(red: 0.616, green: 0.529, blue: 0.741),
        cornerRadiusScale: 0.0,
        onAccent:      Color(red: 0.035, green: 0.000, blue: 0.078), // void on magenta
        usesMonospace: true
    )

    // MARK: vaporwave — light (sun-bleached retro futurism)
    // Light counterpart: keep neon magenta/cyan accents but on a warm peach
    // sky so the theme stays usable in light appearance.

    static let vaporwaveLight = ThemePalette(
        accent:        Color(red: 0.804, green: 0.000, blue: 0.553), // #CD008D deeper magenta
        accentDeep:    Color(red: 0.000, green: 0.529, blue: 0.616), // #00879D deeper cyan
        accentSoft:    Color(red: 0.937, green: 0.443, blue: 0.000), // #EF7100
        accentMuted:   Color(red: 0.804, green: 0.000, blue: 0.553).opacity(0.12),
        bgTop:         Color(red: 1.000, green: 0.918, blue: 0.937), // #FFEAEF pink sky
        bgBottom:      Color(red: 0.965, green: 0.871, blue: 0.973), // #F6DEF8 lavender
        surface:       Color(red: 1.000, green: 0.984, blue: 0.996),
        chipBg:        Color(red: 0.945, green: 0.835, blue: 0.953),
        chipActive:    Color(red: 0.804, green: 0.000, blue: 0.553),
        trackBg:       Color(red: 0.910, green: 0.776, blue: 0.929),
        divider:       Color(red: 0.671, green: 0.451, blue: 0.682).opacity(0.5),
        textPrimary:   Color(red: 0.196, green: 0.063, blue: 0.275), // deep wine
        textSecondary: Color(red: 0.388, green: 0.196, blue: 0.420),
        textTertiary:  Color(red: 0.541, green: 0.376, blue: 0.553),
        cornerRadiusScale: 0.0,
        onAccent:      Color.white,
        usesMonospace: true
    )

    // MARK: sketch — light (canonical pencil-on-paper)
    // Palette from docs/themes/sketch.md: warm paper, soft pencil black,
    // correction-marker red, ballpoint blue. Generous corner radius keeps
    // the playful "wobbly" feel even though true wobble needs custom shapes.

    static let sketchLight = ThemePalette(
        accent:        Color(red: 1.000, green: 0.302, blue: 0.302), // #FF4D4D correction marker
        accentDeep:    Color(red: 0.176, green: 0.365, blue: 0.631), // #2D5DA1 ballpoint blue
        accentSoft:    Color(red: 1.000, green: 0.976, blue: 0.769), // #FFF9C4 post-it yellow
        accentMuted:   Color(red: 1.000, green: 0.302, blue: 0.302).opacity(0.14),
        bgTop:         Color(red: 0.992, green: 0.984, blue: 0.969), // #FDFBF7 warm paper
        bgBottom:      Color(red: 0.973, green: 0.961, blue: 0.929), // slight darken
        surface:       Color(red: 1.000, green: 1.000, blue: 1.000), // index card
        chipBg:        Color(red: 1.000, green: 0.976, blue: 0.769), // post-it
        chipActive:    Color(red: 1.000, green: 0.302, blue: 0.302),
        trackBg:       Color(red: 0.898, green: 0.878, blue: 0.847),
        divider:       Color(red: 0.176, green: 0.176, blue: 0.176), // pencil lead
        textPrimary:   Color(red: 0.176, green: 0.176, blue: 0.176), // #2D2D2D soft black
        textSecondary: Color(red: 0.275, green: 0.275, blue: 0.275),
        textTertiary:  Color(red: 0.435, green: 0.420, blue: 0.392), // muted pencil
        cornerRadiusScale: 1.6,                                       // exaggerated wobble feel
        onAccent:      Color.white
    )

    // MARK: sketch — dark (chalkboard / blueprint)
    // Light is canonical for Sketch; dark variant flips to a chalkboard
    // (deep green-black bg, chalk-white "pencil" lines, post-it accent).

    static let sketchDark = ThemePalette(
        accent:        Color(red: 1.000, green: 0.376, blue: 0.376), // brighter red
        accentDeep:    Color(red: 0.451, green: 0.671, blue: 1.000), // ballpoint pop
        accentSoft:    Color(red: 1.000, green: 0.953, blue: 0.529), // chalkboard yellow chalk
        accentMuted:   Color(red: 1.000, green: 0.376, blue: 0.376).opacity(0.20),
        bgTop:         Color(red: 0.078, green: 0.110, blue: 0.098), // chalkboard
        bgBottom:      Color(red: 0.055, green: 0.082, blue: 0.071),
        surface:       Color(red: 0.118, green: 0.157, blue: 0.137),
        chipBg:        Color(red: 0.157, green: 0.196, blue: 0.176),
        chipActive:    Color(red: 1.000, green: 0.376, blue: 0.376),
        trackBg:       Color(red: 0.196, green: 0.235, blue: 0.212),
        divider:       Color(red: 0.910, green: 0.918, blue: 0.882).opacity(0.55), // chalk
        textPrimary:   Color(red: 0.973, green: 0.969, blue: 0.949), // chalk-white
        textSecondary: Color(red: 0.831, green: 0.831, blue: 0.804),
        textTertiary:  Color(red: 0.612, green: 0.616, blue: 0.580),
        cornerRadiusScale: 1.6,
        onAccent:      Color.white
    )

    // MARK: minimalDark — dark (canonical layered slate + amber)
    // Palette from docs/themes/minimal-dark.md.

    static let minimalDarkDark = ThemePalette(
        accent:        Color(red: 0.961, green: 0.620, blue: 0.043), // #F59E0B amber-500
        accentDeep:    Color(red: 1.000, green: 0.722, blue: 0.180), // bright glow
        accentSoft:    Color(red: 0.961, green: 0.620, blue: 0.043).opacity(0.50),
        accentMuted:   Color(red: 0.961, green: 0.620, blue: 0.043).opacity(0.15),
        bgTop:         Color(red: 0.039, green: 0.039, blue: 0.059), // #0A0A0F deepest slate
        bgBottom:      Color(red: 0.027, green: 0.027, blue: 0.043),
        surface:       Color(red: 0.102, green: 0.102, blue: 0.141), // #1A1A24
        chipBg:        Color(red: 0.071, green: 0.071, blue: 0.102), // #12121A
        chipActive:    Color(red: 0.961, green: 0.620, blue: 0.043),
        trackBg:       Color(red: 0.122, green: 0.122, blue: 0.165),
        divider:       Color.white.opacity(0.08),                    // very subtle
        textPrimary:   Color(red: 0.980, green: 0.980, blue: 0.980), // #FAFAFA
        textSecondary: Color(red: 0.682, green: 0.682, blue: 0.706),
        textTertiary:  Color(red: 0.443, green: 0.443, blue: 0.478), // zinc-500 #71717A
        cornerRadiusScale: 1.0,
        onAccent:      Color(red: 0.039, green: 0.039, blue: 0.059)
    )

    // MARK: minimalDark — light (refined slate paper)
    // Light counterpart: keep amber accent on a cool off-white "paper" so the
    // theme remains coherent if user overrides appearance.

    static let minimalDarkLight = ThemePalette(
        accent:        Color(red: 0.831, green: 0.502, blue: 0.027), // deeper amber
        accentDeep:    Color(red: 0.671, green: 0.404, blue: 0.020),
        accentSoft:    Color(red: 0.831, green: 0.502, blue: 0.027).opacity(0.45),
        accentMuted:   Color(red: 0.831, green: 0.502, blue: 0.027).opacity(0.12),
        bgTop:         Color(red: 0.969, green: 0.969, blue: 0.973), // #F7F7F8
        bgBottom:      Color(red: 0.941, green: 0.941, blue: 0.949),
        surface:       Color(red: 1.000, green: 1.000, blue: 1.000),
        chipBg:        Color(red: 0.918, green: 0.918, blue: 0.929),
        chipActive:    Color(red: 0.831, green: 0.502, blue: 0.027),
        trackBg:       Color(red: 0.890, green: 0.890, blue: 0.902),
        divider:       Color(red: 0.039, green: 0.039, blue: 0.059).opacity(0.08),
        textPrimary:   Color(red: 0.039, green: 0.039, blue: 0.059),
        textSecondary: Color(red: 0.243, green: 0.243, blue: 0.282),
        textTertiary:  Color(red: 0.443, green: 0.443, blue: 0.478),
        cornerRadiusScale: 1.0,
        onAccent:      Color.white
    )

    // MARK: playful — light (canonical violet + confetti pops)
    // Palette from docs/themes/playful-geometric.md.

    static let playfulLight = ThemePalette(
        accent:        Color(red: 0.545, green: 0.361, blue: 0.965), // #8B5CF6 vivid violet
        accentDeep:    Color(red: 0.435, green: 0.231, blue: 0.875),
        accentSoft:    Color(red: 0.957, green: 0.447, blue: 0.714), // #F472B6 hot pink
        accentMuted:   Color(red: 0.545, green: 0.361, blue: 0.965).opacity(0.14),
        bgTop:         Color(red: 1.000, green: 0.992, blue: 0.961), // #FFFDF5 warm cream
        bgBottom:      Color(red: 0.984, green: 0.973, blue: 0.937),
        surface:       Color(red: 1.000, green: 1.000, blue: 1.000),
        chipBg:        Color(red: 0.945, green: 0.961, blue: 0.976), // #F1F5F9 slate 100
        chipActive:    Color(red: 0.545, green: 0.361, blue: 0.965),
        trackBg:       Color(red: 0.886, green: 0.910, blue: 0.941), // slate 200
        divider:       Color(red: 0.118, green: 0.161, blue: 0.231), // chunky dark border
        textPrimary:   Color(red: 0.118, green: 0.161, blue: 0.231), // #1E293B slate 800
        textSecondary: Color(red: 0.275, green: 0.314, blue: 0.388),
        textTertiary:  Color(red: 0.392, green: 0.455, blue: 0.545), // #64748B slate 500
        cornerRadiusScale: 1.4,                                       // chunky friendly
        onAccent:      Color.white
    )

    // MARK: playful — dark (vivid neon party)

    static let playfulDark = ThemePalette(
        accent:        Color(red: 0.671, green: 0.518, blue: 1.000), // brighter violet
        accentDeep:    Color(red: 0.804, green: 0.671, blue: 1.000),
        accentSoft:    Color(red: 1.000, green: 0.553, blue: 0.804), // pink pop
        accentMuted:   Color(red: 0.671, green: 0.518, blue: 1.000).opacity(0.22),
        bgTop:         Color(red: 0.067, green: 0.063, blue: 0.118), // deep night
        bgBottom:      Color(red: 0.043, green: 0.039, blue: 0.082),
        surface:       Color(red: 0.106, green: 0.098, blue: 0.176),
        chipBg:        Color(red: 0.145, green: 0.137, blue: 0.227),
        chipActive:    Color(red: 0.671, green: 0.518, blue: 1.000),
        trackBg:       Color(red: 0.176, green: 0.165, blue: 0.275),
        divider:       Color(red: 1.000, green: 1.000, blue: 1.000).opacity(0.12),
        textPrimary:   Color(red: 0.965, green: 0.957, blue: 0.984),
        textSecondary: Color(red: 0.769, green: 0.745, blue: 0.847),
        textTertiary:  Color(red: 0.553, green: 0.525, blue: 0.659),
        cornerRadiusScale: 1.4,
        onAccent:      Color(red: 0.043, green: 0.039, blue: 0.082)
    )

    // MARK: cyberpunk — dark (canonical neon void, sharp corners, mono)
    // Palette from docs/themes/cyberpunk.md.

    static let cyberpunkDark = ThemePalette(
        accent:        Color(red: 0.000, green: 1.000, blue: 0.533), // #00FF88 matrix green
        accentDeep:    Color(red: 1.000, green: 0.000, blue: 1.000), // #FF00FF magenta
        accentSoft:    Color(red: 0.000, green: 0.831, blue: 1.000), // #00D4FF electric blue
        accentMuted:   Color(red: 0.000, green: 1.000, blue: 0.533).opacity(0.20),
        bgTop:         Color(red: 0.039, green: 0.039, blue: 0.059), // #0A0A0F void
        bgBottom:      Color(red: 0.024, green: 0.024, blue: 0.039),
        surface:       Color(red: 0.071, green: 0.071, blue: 0.102), // #12121A
        chipBg:        Color(red: 0.110, green: 0.110, blue: 0.180), // #1C1C2E
        chipActive:    Color(red: 0.000, green: 1.000, blue: 0.533),
        trackBg:       Color(red: 0.137, green: 0.137, blue: 0.196),
        divider:       Color(red: 0.165, green: 0.165, blue: 0.227), // #2A2A3A
        textPrimary:   Color(red: 0.878, green: 0.878, blue: 0.878), // #E0E0E0
        textSecondary: Color(red: 0.000, green: 1.000, blue: 0.533).opacity(0.85),
        textTertiary:  Color(red: 0.420, green: 0.447, blue: 0.502), // #6B7280
        cornerRadiusScale: 0.2,                                       // chamfer hint
        onAccent:      Color(red: 0.024, green: 0.024, blue: 0.039),
        usesMonospace: true
    )

    // MARK: cyberpunk — light (alt: high-contrast tech-noir paper)

    static let cyberpunkLight = ThemePalette(
        accent:        Color(red: 0.000, green: 0.580, blue: 0.302), // deeper matrix
        accentDeep:    Color(red: 0.690, green: 0.000, blue: 0.690),
        accentSoft:    Color(red: 0.000, green: 0.494, blue: 0.733),
        accentMuted:   Color(red: 0.000, green: 0.580, blue: 0.302).opacity(0.14),
        bgTop:         Color(red: 0.945, green: 0.961, blue: 0.957), // #F1F5F4
        bgBottom:      Color(red: 0.910, green: 0.929, blue: 0.925),
        surface:       Color(red: 1.000, green: 1.000, blue: 1.000),
        chipBg:        Color(red: 0.886, green: 0.910, blue: 0.902),
        chipActive:    Color(red: 0.000, green: 0.580, blue: 0.302),
        trackBg:       Color(red: 0.831, green: 0.871, blue: 0.859),
        divider:       Color(red: 0.043, green: 0.078, blue: 0.071).opacity(0.4),
        textPrimary:   Color(red: 0.043, green: 0.078, blue: 0.071),
        textSecondary: Color(red: 0.149, green: 0.180, blue: 0.176),
        textTertiary:  Color(red: 0.349, green: 0.388, blue: 0.380),
        cornerRadiusScale: 0.2,
        onAccent:      Color.white,
        usesMonospace: true
    )

    // MARK: kinetic — dark (canonical acid yellow on rich black)
    // Palette from docs/themes/kinetic.md.

    static let kineticDark = ThemePalette(
        accent:        Color(red: 0.875, green: 0.882, blue: 0.016), // #DFE104 acid yellow
        accentDeep:    Color(red: 0.961, green: 0.969, blue: 0.180),
        accentSoft:    Color(red: 0.875, green: 0.882, blue: 0.016).opacity(0.55),
        accentMuted:   Color(red: 0.875, green: 0.882, blue: 0.016).opacity(0.18),
        bgTop:         Color(red: 0.035, green: 0.035, blue: 0.043), // #09090B
        bgBottom:      Color(red: 0.020, green: 0.020, blue: 0.027),
        surface:       Color(red: 0.082, green: 0.082, blue: 0.094),
        chipBg:        Color(red: 0.153, green: 0.153, blue: 0.165), // #27272A muted
        chipActive:    Color(red: 0.875, green: 0.882, blue: 0.016),
        trackBg:       Color(red: 0.184, green: 0.184, blue: 0.196),
        divider:       Color(red: 0.247, green: 0.247, blue: 0.275), // #3F3F46 zinc-700
        textPrimary:   Color(red: 0.980, green: 0.980, blue: 0.980), // #FAFAFA
        textSecondary: Color(red: 0.631, green: 0.631, blue: 0.667), // #A1A1AA zinc-400
        textTertiary:  Color(red: 0.443, green: 0.443, blue: 0.478),
        cornerRadiusScale: 0.0,                                       // editorial hard edges
        onAccent:      Color.black
    )

    // MARK: kinetic — light (acid yellow on cream paper)

    static let kineticLight = ThemePalette(
        accent:        Color(red: 0.671, green: 0.682, blue: 0.000), // mustard
        accentDeep:    Color(red: 0.529, green: 0.541, blue: 0.000),
        accentSoft:    Color(red: 0.875, green: 0.882, blue: 0.016),
        accentMuted:   Color(red: 0.671, green: 0.682, blue: 0.000).opacity(0.15),
        bgTop:         Color(red: 0.965, green: 0.965, blue: 0.961),
        bgBottom:      Color(red: 0.929, green: 0.929, blue: 0.925),
        surface:       Color(red: 1.000, green: 1.000, blue: 1.000),
        chipBg:        Color(red: 0.918, green: 0.918, blue: 0.910),
        chipActive:    Color(red: 0.671, green: 0.682, blue: 0.000),
        trackBg:       Color(red: 0.871, green: 0.871, blue: 0.863),
        divider:       Color(red: 0.000, green: 0.000, blue: 0.000).opacity(0.7),
        textPrimary:   Color(red: 0.000, green: 0.000, blue: 0.000),
        textSecondary: Color(red: 0.235, green: 0.235, blue: 0.235),
        textTertiary:  Color(red: 0.451, green: 0.451, blue: 0.451),
        cornerRadiusScale: 0.0,
        onAccent:      Color.black
    )

    // MARK: artDeco — dark (canonical obsidian + gold)
    // Palette from docs/themes/art-deco.md.

    static let artDecoDark = ThemePalette(
        accent:        Color(red: 0.831, green: 0.686, blue: 0.216), // #D4AF37 metallic gold
        accentDeep:    Color(red: 0.949, green: 0.910, blue: 0.769), // light gold glow
        accentSoft:    Color(red: 0.118, green: 0.239, blue: 0.349), // #1E3D59 midnight blue
        accentMuted:   Color(red: 0.831, green: 0.686, blue: 0.216).opacity(0.20),
        bgTop:         Color(red: 0.039, green: 0.039, blue: 0.039), // #0A0A0A obsidian
        bgBottom:      Color(red: 0.020, green: 0.020, blue: 0.020),
        surface:       Color(red: 0.078, green: 0.078, blue: 0.078), // #141414 charcoal
        chipBg:        Color(red: 0.118, green: 0.239, blue: 0.349), // midnight blue chip
        chipActive:    Color(red: 0.831, green: 0.686, blue: 0.216),
        trackBg:       Color(red: 0.110, green: 0.110, blue: 0.110),
        divider:       Color(red: 0.831, green: 0.686, blue: 0.216).opacity(0.55), // gold border
        textPrimary:   Color(red: 0.949, green: 0.941, blue: 0.894), // #F2F0E4 champagne
        textSecondary: Color(red: 0.788, green: 0.745, blue: 0.643),
        textTertiary:  Color(red: 0.533, green: 0.533, blue: 0.533), // #888888 pewter
        cornerRadiusScale: 0.0,
        onAccent:      Color(red: 0.020, green: 0.020, blue: 0.020)
    )

    // MARK: artDeco — light (ivory + gold + midnight)

    static let artDecoLight = ThemePalette(
        accent:        Color(red: 0.671, green: 0.541, blue: 0.137), // deeper antique gold
        accentDeep:    Color(red: 0.541, green: 0.420, blue: 0.094),
        accentSoft:    Color(red: 0.118, green: 0.239, blue: 0.349),
        accentMuted:   Color(red: 0.671, green: 0.541, blue: 0.137).opacity(0.14),
        bgTop:         Color(red: 0.961, green: 0.953, blue: 0.918), // ivory
        bgBottom:      Color(red: 0.929, green: 0.910, blue: 0.855),
        surface:       Color(red: 0.984, green: 0.976, blue: 0.945),
        chipBg:        Color(red: 0.890, green: 0.871, blue: 0.812),
        chipActive:    Color(red: 0.671, green: 0.541, blue: 0.137),
        trackBg:       Color(red: 0.855, green: 0.835, blue: 0.776),
        divider:       Color(red: 0.671, green: 0.541, blue: 0.137).opacity(0.6),
        textPrimary:   Color(red: 0.078, green: 0.106, blue: 0.149), // deep navy ink
        textSecondary: Color(red: 0.196, green: 0.235, blue: 0.290),
        textTertiary:  Color(red: 0.388, green: 0.388, blue: 0.388),
        cornerRadiusScale: 0.0,
        onAccent:      Color(red: 0.961, green: 0.953, blue: 0.918)
    )
}

// MARK: - Theme proxy

/// Static facade resolving to `ThemePalette.current`. Existing call sites
/// (`Theme.accent`, `Theme.bgGradient`, etc.) continue to work unchanged;
/// `ThemedRoot` re-renders subtrees when (`AppTheme`, `ColorScheme`) change.
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
    static var onAccent:      Color { ThemePalette.current.onAccent }

    static var bgGradient: LinearGradient {
        LinearGradient(colors: [bgTop, bgBottom], startPoint: .top, endPoint: .bottom)
    }

    /// Multiplier for default corner radii. Brutalist theme returns 0 to give
    /// hard-edged blocks; all other themes return 1.
    static var cornerScale: CGFloat { ThemePalette.current.cornerRadiusScale }

    /// Apply the active theme's corner scale to a base radius.
    static func radius(_ base: CGFloat) -> CGFloat { base * cornerScale }

    /// True when the active theme prefers a monospaced text design across
    /// the UI (e.g. Terminal). Use with `Theme.body(size:weight:)` so views
    /// pick up the design switch automatically.
    static var usesMono: Bool { ThemePalette.current.usesMonospace }

    /// Body-text font that respects the active theme's `usesMonospace` flag.
    static func body(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: usesMono ? .monospaced : .default)
    }

    /// Heading font; same logic as `body(size:weight:)` but also caps to
    /// a sturdier weight for monospaced themes so text shows up at small sizes.
    static func heading(size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size,
                weight: usesMono && weight == .regular ? .medium : weight,
                design: usesMono ? .monospaced : .default)
    }
}

// MARK: - Themed semantic colors

/// Threshold severity colors that adapt to color scheme for legibility.
enum SeverityColor {
    static func warning(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 1.00, green: 0.84, blue: 0.30)
            : Color.yellow.opacity(0.9)
    }
    static func high(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 1.00, green: 0.62, blue: 0.20)
            : Color.orange
    }
    static func critical(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 1.00, green: 0.45, blue: 0.42)
            : Color.red.opacity(0.9)
    }
    static func sessionReset(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 0.40, green: 0.85, blue: 0.55)
            : Color.green.opacity(0.8)
    }
    static func positive(_ scheme: ColorScheme) -> Color { sessionReset(scheme) }
    static func info(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 0.48, green: 0.72, blue: 1.00)   // sky-blue on dark
            : Color(red: 0.20, green: 0.42, blue: 0.78)   // steel-blue on light
    }
}

// MARK: - ThemedRoot

/// Root wrapper: resolves `ThemePalette.current` from the current
/// `(AppTheme, ColorScheme)` pair and forces subtree rebuild via `.id` when
/// either changes. Also applies the user's appearance override.
struct ThemedRoot<Content: View>: View {
    @Environment(\.colorScheme) private var systemScheme
    @Bindable var store: AppStore
    @ViewBuilder var content: () -> Content

    private var effectiveScheme: ColorScheme {
        store.appAppearance.preferredColorScheme ?? systemScheme
    }

    var body: some View {
        let scheme = effectiveScheme
        // Resolve global palette synchronously so descendants reading
        // `Theme.*` during the same render pass see the correct values.
        ThemePalette.current = store.appTheme.palette(for: scheme)

        return content()
            .id("\(store.appTheme.rawValue)-\(scheme == .dark ? "d" : "l")")
            .preferredColorScheme(store.appAppearance.preferredColorScheme)
    }
}

// MARK: - SectionDotLabel

struct SectionDotLabel: View {
    let title: String
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(Theme.accent).frame(width: 5, height: 5)
                .accessibilityHidden(true)
            Text(L10n.t(title))
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
                .accessibilityAddTraits(.isHeader)
        }
    }
}
