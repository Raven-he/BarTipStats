import SwiftUI

/// 今日汇总卡片（首页顶部）
struct DailySummaryCard: View {
    let todayTotal: Double
    let recordCount: Int

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("今日小费")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                BigNumberText(value: todayTotal, font: .system(size: 42, weight: .black, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: 20)

            VStack(alignment: .trailing, spacing: 8) {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("笔数")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    Text("\(recordCount)")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.white)
                }

                if recordCount > 0 {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("均价")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text((todayTotal / Double(max(recordCount, 1))).currencyFormat)
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(.tipAmount)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.appAccent.opacity(0.2), lineWidth: 1)
        }
    }
}

#Preview {
    DailySummaryCard(todayTotal: 5888, recordCount: 12)
        .preferredColorScheme(.dark)
        .padding()
}
