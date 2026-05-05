import SwiftUI

enum Theme {
    static let accent       = Color(red: 0.76, green: 0.38, blue: 0.11)
    static let accentDeep   = Color(red: 0.55, green: 0.23, blue: 0.06)
    static let accentSoft   = Color(red: 0.84, green: 0.60, blue: 0.42)
    static let accentMuted  = Color(red: 0.78, green: 0.45, blue: 0.20).opacity(0.18)

    static let bgTop        = Color(red: 0.93, green: 0.92, blue: 0.90)
    static let bgBottom     = Color(red: 0.86, green: 0.85, blue: 0.83)

    static let surface      = Color(red: 0.98, green: 0.97, blue: 0.95)
    static let chipBg       = Color(red: 0.84, green: 0.82, blue: 0.80)
    static let chipActive   = Color(red: 0.76, green: 0.38, blue: 0.11)
    static let trackBg      = Color(red: 0.80, green: 0.78, blue: 0.75)
    static let divider      = Color(red: 0.79, green: 0.76, blue: 0.72).opacity(0.6)

    static let textPrimary   = Color(red: 0.11, green: 0.11, blue: 0.11)
    static let textSecondary = Color(red: 0.38, green: 0.36, blue: 0.34)
    static let textTertiary  = Color(red: 0.55, green: 0.53, blue: 0.50)

    static let bgGradient = LinearGradient(
        colors: [bgTop, bgBottom],
        startPoint: .top,
        endPoint: .bottom
    )
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
