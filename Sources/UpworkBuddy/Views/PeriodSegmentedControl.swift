import SwiftUI

struct PeriodSegmentedControl: View {
    let selection: Period
    let onSelect: (Period) -> Void

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Period.allCases) { period in
                Button {
                    onSelect(period)
                } label: {
                    Text(period.label)
                        .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 7)
                                .fill(selection == period ? Color.accentColor.opacity(0.18) : .clear)
                        )
                        .foregroundStyle(selection == period ? Color.accentColor : .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: 9)
                .fill(.quaternary.opacity(0.5))
        )
    }
}
