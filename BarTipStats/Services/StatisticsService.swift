import Foundation

/// 纯函数统计工具（可测试）
enum StatisticsService {

    /// 按日期范围过滤
    static func filter(_ tips: [TipRecord], from startDate: Date, to endDate: Date) -> [TipRecord] {
        tips.filter { $0.date >= startDate && $0.date <= endDate }
    }

    /// 计算总额
    static func totalAmount(_ tips: [TipRecord]) -> Double {
        tips.reduce(0) { $0 + $1.amount }
    }

    /// 计算平均值
    static func averageAmount(_ tips: [TipRecord]) -> Double {
        guard !tips.isEmpty else { return 0 }
        return totalAmount(tips) / Double(tips.count)
    }

    /// 按员工分组统计
    static func groupByEmployee(_ tips: [TipRecord]) -> [(Employee, Double, Int)] {
        let grouped = Dictionary(grouping: tips) { $0.employee?.id }
        return grouped.compactMap { _, records in
            guard let employee = records.first?.employee else { return nil }
            return (employee, totalAmount(records), records.count)
        }.sorted { $0.1 > $1.1 }
    }

    /// 按岗位分组统计
    static func groupByPosition(_ tips: [TipRecord]) -> [Position: Double] {
        let grouped = Dictionary(grouping: tips) { $0.employee?.position }
        var result: [Position: Double] = [:]
        for (position, records) in grouped {
            if let pos = position {
                result[pos] = totalAmount(records)
            }
        }
        return result
    }

    /// 生成 Excel 报表数据（预留接口）
    static func exportData(_ tips: [TipRecord]) -> [[String: Any]] {
        tips.sorted { $0.date > $1.date }.map { record in
            [
                "员工": record.employee?.name ?? "",
                "岗位": record.employee?.position.displayName ?? "",
                "场地": record.venue?.name ?? "",
                "金额": record.amount,
                "时间": record.date.fullDateTime,
                "备注": record.note
            ]
        }
    }
}
