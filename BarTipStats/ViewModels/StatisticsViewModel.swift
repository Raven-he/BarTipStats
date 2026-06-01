import Foundation
import SwiftData

struct AggregatedStats {
    let total: Double
    let count: Int
    let average: Double
    let records: [TipRecord]
}

struct EmployeePeriodStats: Identifiable {
    let id = UUID()
    let employee: Employee
    let total: Double
    let count: Int
}

@Observable
@MainActor
final class StatisticsViewModel {
    var selectedPeriod: StatPeriod = .day

    /// 按选定周期过滤记录
    func filterByPeriod(_ tips: [TipRecord]) -> [TipRecord] {
        let now = Date()
        switch selectedPeriod {
        case .day:
            return tips.filter { $0.date.isToday }
        case .week:
            let start = now.startOfWeek
            return tips.filter { $0.date >= start }
        case .month:
            let start = now.startOfMonth
            return tips.filter { $0.date >= start }
        }
    }

    /// 聚合统计数据
    func aggregate(_ tips: [TipRecord]) -> AggregatedStats {
        let filtered = filterByPeriod(tips)
        let total = filtered.reduce(0) { $0 + $1.amount }
        let count = filtered.count
        let average = count > 0 ? total / Double(count) : 0
        return AggregatedStats(
            total: total,
            count: count,
            average: average,
            records: filtered.sorted { $0.date > $1.date }
        )
    }

    /// 按员工聚合周期数据（用于排名）
    func perEmployeeStats(_ tips: [TipRecord]) -> [EmployeePeriodStats] {
        let filtered = filterByPeriod(tips)
        let grouped = Dictionary(grouping: filtered) { $0.employee?.id }
        return grouped.compactMap { _, records in
            guard let employee = records.first?.employee else { return nil }
            return EmployeePeriodStats(
                employee: employee,
                total: records.reduce(0) { $0 + $1.amount },
                count: records.count
            )
        }.sorted { $0.total > $1.total }
    }
}
