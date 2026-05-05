import SwiftUI

struct PeriodSegmentedControl: View {
    let selection: Period
    let onSelect: (Period) -> Void

    var body: some View {
        HStack(spacing: 6) {
            ForEach(Period.allCases) { period in
                Button {
                    onSelect(period)
                } label: {
                    Text(period.label)
                        .font(.system(size: 12, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selection == period ? Color.white : Theme.chipBg.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selection == period ? Theme.accent.opacity(0.0) : Color.clear, lineWidth: 0)
                        )
                        .foregroundStyle(selection == period ? Theme.textPrimary : Theme.textSecondary)
                        .shadow(color: selection == period ? Color.black.opacity(0.06) : .clear, radius: 1, y: 0.5)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
