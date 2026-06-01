import Foundation

extension NumberFormatter {
    /// 货币格式化器：显示为 ¥1,000 格式
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "¥"
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = ","
        return formatter
    }()

    /// 带两位小数的货币格式
    static let currencyPrecise: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "¥"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
}

extension Double {
    /// 格式化为人民币显示
    var currencyFormat: String {
        NumberFormatter.currency.string(from: NSNumber(value: self)) ?? "¥0"
    }

    /// 格式化为精确货币显示
    var currencyPreciseFormat: String {
        NumberFormatter.currencyPrecise.string(from: NSNumber(value: self)) ?? "¥0.00"
    }
}
