import SwiftUI
import SwiftData

/// 数据统计页（Tab 2）
struct StatisticsView: View {
    @State private var vm = StatisticsViewModel()

    @Query(sort: \TipRecord.date, order: .reverse)
    private var allTips: [TipRecord]

    private var stats: AggregatedStats {
        vm.aggregate(allTips)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    PeriodSelector(selection: $vm.selectedPeriod)
                        .padding(.vertical, 8)

                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 14
                    ) {
                        AggregatedStatCard(
                            title: "\(vm.selectedPeriod.rawValue)总计",
                            value: stats.total.currencyFormat,
                            subtitle: "\(stats.count) 笔记录"
                        )

                        AggregatedStatCard(
                            title: "平均每笔",
                            value: stats.average.currencyFormat,
                            valueColor: .white,
                            subtitle: stats.count > 0 ? "共 \(stats.count) 笔" : nil
                        )
                    }

                    EmployeeStatsSummary(entries: vm.perEmployeeStats(allTips))
                    TransactionList(records: stats.records)
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("数据统计")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

/// 员工统计汇总
struct EmployeeStatsSummary: View {
    let entries: [EmployeePeriodStats]

    private func positionColor(_ position: Position) -> Color {
        switch position {
        case .dj: return .posDJ
        case .ds: return .posDS
        case .manager: return .posManager
        case .marketing: return .posMarketing
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("员工统计")
                .font(.headline.weight(.semibold))

            if entries.isEmpty {
                HStack {
                    Spacer()
                    Text("暂无数据")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .padding(.vertical, 20)
                    Spacer()
                }
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(Array(entries.prefix(10).enumerated()), id: \.element.id) { index, entry in
                        HStack {
                            Text(entry.employee.name)
                                .font(.subheadline.weight(.medium))
                            Text(entry.employee.position.displayName)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(positionColor(entry.employee.position).opacity(0.2))
                                .clipShape(Capsule())

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text(entry.total.currencyFormat)
                                    .font(.body.weight(.bold))
                                    .foregroundStyle(.tipAmount)
                                Text("\(entry.count) 笔")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .padding(.vertical, 8)

                        if index < entries.prefix(10).count - 1 {
                            Divider()
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
                .stroke(.appAccent.opacity(0.12), lineWidth: 1)
        }
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
        .preferredColorScheme(.dark)
}
