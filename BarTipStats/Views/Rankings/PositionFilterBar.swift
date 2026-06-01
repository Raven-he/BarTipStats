import SwiftUI

/// 岗位筛选条
struct PositionFilterBar: View {
    @Binding var selectedPosition: Position?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "全部",
                    isSelected: selectedPosition == nil,
                    action: { selectedPosition = nil }
                )

                ForEach(Position.allCases) { position in
                    FilterChip(
                        title: position.displayName,
                        isSelected: selectedPosition == position,
                        action: { selectedPosition = position }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.appAccent : Color.gray.opacity(0.2))
                .foregroundStyle(isSelected ? .white : .secondary)
                .clipShape(Capsule())
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    PositionFilterBar(selectedPosition: .constant(.dj))
        .preferredColorScheme(.dark)
}
