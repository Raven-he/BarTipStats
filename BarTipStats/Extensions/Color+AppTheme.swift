import SwiftUI

// MARK: - 暖金配色主题（适配酒吧暗光环境）
extension Color {
    // 主色调
    static let appAccent = Color(hex: "FF9500")      // 暖金橙
    static let appAccentDark = Color(hex: "E68600")   // 深橙
    static let appGold = Color(hex: "FFD700")         // 金色
    static let appSilver = Color(hex: "C0C0C0")       // 银色
    static let appBronze = Color(hex: "CD7F32")       // 铜色

    // 金额颜色
    static let tipAmount = Color(hex: "FFD60A")       // 亮金 — 小费金额
    static let tipAmountRed = Color(hex: "FF3B30")    // 中国红 — 重要金额

    // 背景色
    static let appBackground = Color(hex: "1A1A2E")   // 深紫黑底
    static let appSurface = Color(hex: "1E1E32")      // 卡片底色
    static let appSurfaceAlt = Color(hex: "2A2A42")   // 浅色卡片
    static let appCardBorder = Color(hex: "FF9500").opacity(0.15) // 金边框

    // 文字色
    static let appTextPrimary = Color(hex: "FFFFFF")
    static let appTextSecondary = Color(hex: "AAAAAA")
    static let appTextTertiary = Color(hex: "666666")

    // 岗位配色
    static let posDJ = Color(hex: "FF9500")           // DJ - 橙
    static let posDS = Color(hex: "BF5AF2")           // DS - 紫
    static let posManager = Color(hex: "FF3B30")      // 经理 - 红
    static let posMarketing = Color(hex: "34C759")    // 营销 - 绿

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        self.init(
            red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgbValue & 0x0000FF) / 255.0
        )
    }
}
