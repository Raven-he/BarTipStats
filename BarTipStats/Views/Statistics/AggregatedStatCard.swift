import SwiftUI

/// 聚合统计卡片（暖金风格）
struct AggregatedStatCard: View {
    let title: String
    let value: String
    var valueColor: Color = .tipAmount
    var subtitle: String? = nil

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.system(size: 42, weight: .black, design: .monospaced))
                .foregroundStyle(valueColor)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.appAccent.opacity(0.12), lineWidth: 1)
        }
    }
}

#Preview {
    HStack {
        AggregatedStatCard(title: "总计", value: "¥12,888")
        AggregatedStatCard(title: "笔数", value: "24", valueColor: .white)
    }
    .padding()
    .preferredColorScheme(.dark)
}
