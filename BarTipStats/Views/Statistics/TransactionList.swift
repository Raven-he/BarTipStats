import SwiftUI

/// 单笔交易行
struct TransactionRow: View {
    let record: TipRecord

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(record.date.shortDate)
                    .font(.caption.weight(.medium))
                Text(record.date.preciseTime)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .frame(width: 56, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(record.employee?.name ?? "未知")
                    .font(.subheadline.weight(.medium))
                Text(record.venue?.name ?? "")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(record.amount.currencyFormat)
                .font(.body.weight(.bold))
                .foregroundStyle(.tipAmount)
        }
        .padding(.vertical, 10)
    }
}

/// 周期内交易明细列表
struct TransactionList: View {
    let records: [TipRecord]
    var maxDisplay: Int = 50

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("明细流水")
                    .font(.headline.weight(.semibold))
                Spacer()
                Text("最近 \(min(records.count, maxDisplay)) 笔")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if records.isEmpty {
                HStack {
                    Spacer()
                    Text("暂无记录")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .padding(.vertical, 40)
                    Spacer()
                }
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(Array(records.prefix(maxDisplay).enumerated()), id: \.element.id) { index, record in
                        TransactionRow(record: record)
                        if index < min(records.count, maxDisplay) - 1 {
                            Divider()
                                .padding(.leading, 8)
                        }
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.appAccent.opacity(0.15), lineWidth: 1)
        }
    }
}

#Preview {
    TransactionList(records: [])
        .preferredColorScheme(.dark)
        .padding()
}
