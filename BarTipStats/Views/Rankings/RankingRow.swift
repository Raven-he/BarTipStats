import SwiftUI

/// 单条排名行
struct RankingRow: View {
    let entry: RankingEntry

    private var rankColor: Color {
        switch entry.rank {
        case 1: return .appGold
        case 2: return .appSilver
        case 3: return .appBronze
        default: return .secondary
        }
    }

    private var rankIcon: String {
        switch entry.rank {
        case 1: return "crown.fill"
        case 2: return "medal.fill"
        case 3: return "medal.fill"
        default: return ""
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                if entry.rank <= 3 {
                    Image(systemName: rankIcon)
                        .font(.title3)
                        .foregroundStyle(rankColor)
                } else {
                    Text("\(entry.rank)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 36)

            ZStack {
                Circle()
                    .fill(Color.appAccent.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(entry.employee.name.prefix(1))
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.appAccent)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(entry.employee.name)
                    .font(.body.weight(.semibold))
                Text(entry.employee.position.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.gray.opacity(0.15))
                    .clipShape(Capsule())
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(entry.totalAmount.currencyFormat)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.tipAmount)
                    .monospacedDigit()
                Text("\(entry.recordCount) 笔")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

#Preview {
    let emp = Employee(name: "阿强", position: .dj)
    let entry = RankingEntry(rank: 1, employee: emp, totalAmount: 8888, recordCount: 16)
    return RankingRow(entry: entry)
        .preferredColorScheme(.dark)
        .padding(.horizontal)
}
