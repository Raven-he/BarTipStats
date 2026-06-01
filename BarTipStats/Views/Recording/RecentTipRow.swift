import SwiftUI

/// 最近一笔小费记录行
struct RecentTipRow: View {
    let record: TipRecord

    var body: some View {
        HStack(spacing: 14) {
            // 头像圆圈
            ZStack {
                Circle()
                    .fill(Color.appAccent.opacity(0.2))
                    .frame(width: 44, height: 44)
                Text(record.employee?.name.prefix(1) ?? "?")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.appAccent)
            }

            // 中间信息
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(record.employee?.name ?? "未知")
                        .font(.body.weight(.semibold))
                    Text(record.employee?.position.displayName ?? "")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.gray.opacity(0.2))
                        .clipShape(Capsule())
                }

                HStack(spacing: 4) {
                    Image(systemName: "table.furniture.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text(record.venue?.name ?? "未知场地")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text(record.date.preciseTime)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            // 右侧金额
            Text(record.amount.currencyFormat)
                .font(.title3.weight(.bold))
                .foregroundStyle(.tipAmount)
        .padding(.vertical, 6)
    }
}

#Preview {
    let emp = Employee(name: "Alex", position: .dj)
    let ven = Venue(name: "卡座888")
    let record = TipRecord(amount: 888, employee: emp, venue: ven)

    return RecentTipRow(record: record)
        .preferredColorScheme(.dark)
        .padding(.horizontal)
}
