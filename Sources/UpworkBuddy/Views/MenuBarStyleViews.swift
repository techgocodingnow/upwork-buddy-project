import SwiftUI

/// Visual primitive that renders one menu-bar metric style. Used both for the
/// preview tiles in Settings and for the live status-item icon (via ImageRenderer).
///
/// `progress` is 0...1+ (over-target tolerated). `label` is the short caption
/// rendered into Battery / Percentage variants — typically the period name
/// ("Today", "Week"), the percentage ("60%"), or a count ("5h/8h").
struct MenuBarStylePreview: View {
    let style: MenuBarMetricStyle
    let progress: Double
    let label: String
    var width: CGFloat = 92
    var height: CGFloat = 36

    var body: some View {
        ZStack {
            switch style {
            case .batteryClassic: batteryClassic
            case .progressBar:    progressBar
            case .percentage:     percentage
            case .iconWithBar:    iconWithBar
            case .compact:        compact
            }
        }
        .frame(width: width, height: height)
    }

    // MARK: - Battery (Classic) — pill with label centered + progress fill behind

    private var batteryClassic: some View {
        let radius: CGFloat = 6
        return ZStack {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(Theme.divider.opacity(0.7), lineWidth: 1)
            GeometryReader { geo in
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: radius - 2, style: .continuous)
                        .fill(fillColor)
                        .frame(width: geo.size.width * clamped)
                    Spacer(minLength: 0)
                }
                .padding(2)
            }
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, 6)
        }
    }

    // MARK: - Progress Bar — pill, no label

    private var progressBar: some View {
        let radius: CGFloat = 8
        return RoundedRectangle(cornerRadius: radius, style: .continuous)
            .strokeBorder(Theme.divider.opacity(0.6), lineWidth: 1)
            .background(
                GeometryReader { geo in
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: radius - 2, style: .continuous)
                            .fill(fillColor)
                            .frame(width: geo.size.width * clamped)
                        Spacer(minLength: 0)
                    }
                    .padding(2)
                }
            )
    }

    // MARK: - Percentage — bare label, big

    private var percentage: some View {
        Text(label)
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(fillColor)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
    }

    // MARK: - Icon with Bar — open ring

    private var iconWithBar: some View {
        ZStack {
            Circle()
                .stroke(Theme.divider.opacity(0.6), lineWidth: 2.5)
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(fillColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: min(height - 4, 26), height: min(height - 4, 26))
    }

    // MARK: - Compact — tiny dot

    private var compact: some View {
        Circle()
            .fill(fillColor)
            .frame(width: 8, height: 8)
    }

    // MARK: helpers

    private var clamped: Double { max(0, min(progress, 1)) }

    private var fillColor: Color {
        progress > 1 ? Theme.accentDeep : Theme.accent
    }
}

/// Selectable tile used in the Settings → Menu Bar Metrics picker. Mirrors the
/// reference design's bordered "preview card" with caption underneath.
struct MenuBarStylePickerTile: View {
    let style: MenuBarMetricStyle
    let isSelected: Bool
    let sampleProgress: Double
    let sampleLabel: String
    let action: () -> Void

    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(isSelected ? Theme.accent.opacity(0.10) : Theme.surface.opacity(0.85))
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(
                            isSelected ? Theme.accent : Theme.divider.opacity(hovering ? 0.9 : 0.5),
                            lineWidth: isSelected ? 1.4 : 0.6
                        )
                    MenuBarStylePreview(
                        style: style,
                        progress: sampleProgress,
                        label: sampleLabel,
                        width: 84,
                        height: 32
                    )
                }
                .frame(height: 56)

                Text(style.label)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? Theme.textPrimary : Theme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
        .accessibilityLabel("\(style.label) menu bar style")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
