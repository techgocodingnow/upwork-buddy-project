import SwiftUI

struct PeriodSegmentedControl: View {
    let selection: Period
    let onSelect: (Period) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Period.allCases) { period in
                let isSelected = selection == period
                Button {
                    onSelect(period)
                } label: {
                    Text(period.label)
                        .font(Theme.body(size: 12, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                        .frame(maxWidth: .infinity, minHeight: 36, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.radius(6))
                                .fill(isSelected ? Theme.accent.opacity(0.22) : Theme.chipBg.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.radius(6))
                                .strokeBorder(isSelected ? Theme.accent.opacity(0.45) : Color.clear, lineWidth: 0.5)
                        )
                        .foregroundStyle(isSelected ? Theme.textPrimary : Theme.textSecondary)
                        .shadow(color: isSelected ? Theme.accent.opacity(0.12) : .clear, radius: 1, y: 0.5)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(period.label)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(L10n.t("Time period"))
    }
}
