import Foundation
import SwiftData

struct RankingEntry: Identifiable {
    let id = UUID()
    let rank: Int
    let employee: Employee
    let totalAmount: Double
    let recordCount: Int
}

@Observable
@MainActor
final class RankingsViewModel {
    var selectedPeriod: StatPeriod = .day
    var selectedPosition: Position? = nil

    /// 过滤周期
    private func filterByPeriod(_ tips: [TipRecord]) -> [TipRecord] {
        let now = Date()
        switch selectedPeriod {
        case .day:
            return tips.filter { $0.date.isToday }
        case .week:
            return tips.filter { $0.date >= now.startOfWeek }
        case .month:
            return tips.filter { $0.date >= now.startOfMonth }
        }
    }

    /// 过滤岗位 + 周期
    private func filterTips(_ tips: [TipRecord]) -> [TipRecord] {
        var filtered = filterByPeriod(tips)
        if let pos = selectedPosition {
            filtered = filtered.filter { $0.employee?.position == pos }
        }
        return filtered
    }

    /// 计算排名
    func computeRankings(from allTips: [TipRecord]) -> [RankingEntry] {
        let filtered = filterTips(allTips)
        let grouped = Dictionary(grouping: filtered) { $0.employee?.id }

        let stats: [(Employee, Double, Int)] = grouped.compactMap { _, records in
            guard let employee = records.first?.employee else { return nil }
            let total = records.reduce(0) { $0 + $1.amount }
            return (employee, total, records.count)
        }.sorted { $0.1 > $1.1 }

        return stats.enumerated().map { index, data in
            RankingEntry(
                rank: index + 1,
                employee: data.0,
                totalAmount: data.1,
                recordCount: data.2
            )
        }
    }
}
