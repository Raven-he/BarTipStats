import Foundation
import SwiftData
import UIKit

@Observable
@MainActor
final class RecordingViewModel {
    var selectedEmployee: Employee?
    var selectedVenue: Venue?
    var amountText: String = ""
    var note: String = ""
    var showSuccess = false

    /// 解析后的金额
    var amount: Double { Double(amountText) ?? 0 }

    /// 表单是否有效
    var isValid: Bool {
        selectedEmployee != nil
            && selectedVenue != nil
            && amount > 0
    }

    /// 提交小费记录
    func submit(context: ModelContext) {
        guard isValid,
              let employee = selectedEmployee,
              let venue = selectedVenue else { return }

        let record = TipRecord(
            amount: amount,
            employee: employee,
            venue: venue,
            note: note
        )
        context.insert(record)

        // 震动反馈
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()

        // 重置表单
        selectedEmployee = nil
        selectedVenue = nil
        amountText = ""
        note = ""

        showSuccess = true
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            showSuccess = false
        }
    }

    /// 计算员工今日小费总额
    func todayTotal(for employee: Employee) -> Double {
        employee.tips
            .filter { $0.date.isToday }
            .reduce(0) { $0 + $1.amount }
    }

    /// 今日所有记录
    static func todayTips(_ allTips: [TipRecord]) -> [TipRecord] {
        allTips.filter { $0.date.isToday }
            .sorted { $0.date > $1.date }
    }
}
