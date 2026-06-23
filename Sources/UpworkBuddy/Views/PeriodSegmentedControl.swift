import SwiftUI

struct PeriodSegmentedControl: View {
    let selection: Period
    let onSelect: (Period) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Period.allCases) { period in
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
                                .fill(selection == period ? Theme.surface : Theme.chipBg.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.radius(6))
                                .strokeBorder(selection == period ? Theme.divider.opacity(0.12) : Color.clear, lineWidth: 0.5)
                        )
                        .foregroundStyle(selection == period ? Theme.textPrimary : Theme.textSecondary)
                        .shadow(color: selection == period ? Color.black.opacity(0.03) : .clear, radius: 1, y: 0.5)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(period.label)
                .accessibilityAddTraits(selection == period ? .isSelected : [])
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(L10n.t("Time period"))
    }
}
