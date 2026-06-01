import SwiftUI

/// 历史记录行
struct HistoryRow: View {
    let record: TipRecord

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(.appAccent.opacity(0.15))
                    .frame(width: 40, height: 40)
                Text(record.employee?.name.prefix(1) ?? "?")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.appAccent)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(record.employee?.name ?? "未知")
                        .font(.subheadline.weight(.semibold))
                    Text(record.employee?.position.displayName ?? "")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(.gray.opacity(0.15))
                        .clipShape(Capsule())
                }

                HStack(spacing: 4) {
                    Image(systemName: "table.furniture.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(.orange)
                    Text(record.venue?.name ?? "")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text(record.date.fullDateTime)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            Text(record.amount.currencyFormat)
                .font(.body.weight(.bold))
                .foregroundStyle(.tipAmount)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let emp = Employee(name: "小雅", position: .ds)
    let ven = Venue(name: "散台A区")
    let record = TipRecord(amount: 500, employee: emp, venue: ven)
    return HistoryRow(record: record)
        .preferredColorScheme(.dark)
        .padding(.horizontal)
}
