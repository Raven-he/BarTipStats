import SwiftUI
import SwiftData

/// 排名榜单页（Tab 3）
struct RankingsView: View {
    @State private var vm = RankingsViewModel()

    @Query(sort: \TipRecord.date, order: .reverse)
    private var allTips: [TipRecord]

    private var rankings: [RankingEntry] {
        vm.computeRankings(from: allTips)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 周期选择 + 岗位筛选
                VStack(spacing: 12) {
                    PeriodSelector(selection: $vm.selectedPeriod)
                    PositionFilterBar(selectedPosition: $vm.selectedPosition)
                }
                .padding(.vertical, 12)
                .background(Color.appBackground)

                // 排名列表
                if rankings.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "trophy",
                        title: "暂无排名数据",
                        message: "当前周期还没有小费记录"
                    )
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            // 前三名高亮展示
                            if rankings.count >= 3 {
                                PodiumView(top3: Array(rankings.prefix(3)))
                                    .padding(.vertical, 20)
                            }

                            // 排名列表
                            VStack(spacing: 0) {
                                ForEach(rankings) { entry in
                                    RankingRow(entry: entry)
                                        .padding(.horizontal)

                                    if entry.id != rankings.last?.id {
                                        Divider()
                                            .padding(.leading, 100)
                                    }
                                }
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(Color.appBackground)
            .navigationTitle("排名榜单")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

/// 领奖台展示（前三名）
struct PodiumView: View {
    let top3: [RankingEntry]

    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {
            // 第二名
            if top3.count >= 2 {
                PodiumPerson(
                    entry: top3[1],
                    height: 80,
                    color: .appSilver,
                    rank: 2
                )
            }

            // 第一名
            PodiumPerson(
                entry: top3[0],
                height: 110,
                color: .appGold,
                rank: 1
            )

            // 第三名
            if top3.count >= 3 {
                PodiumPerson(
                    entry: top3[2],
                    height: 60,
                    color: .appBronze,
                    rank: 3
                )
            }
        }
        .padding(.horizontal)
    }
}

struct PodiumPerson: View {
    let entry: RankingEntry
    let height: CGFloat
    let color: Color
    let rank: Int

    var body: some View {
        VStack(spacing: 8) {
            Text(entry.employee.name)
                .font(.caption.weight(.semibold))
                .lineLimit(1)

            Text(entry.totalAmount.currencyFormat)
                .font(.caption.weight(.bold))
                .foregroundStyle(.tipAmount)

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.3))
                    .frame(height: height)

                Image(systemName: rank == 1 ? "crown.fill" : "medal.fill")
                    .font(.title2)
                    .foregroundStyle(color)
            }

            Text("第\(rank)名")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    RankingsView()
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
        .preferredColorScheme(.dark)
}
