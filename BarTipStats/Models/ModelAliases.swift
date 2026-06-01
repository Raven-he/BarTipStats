import Foundation

// MARK: - 岗位枚举
enum Position: String, CaseIterable, Codable, Identifiable {
    case dj = "DJ"
    case ds = "DS"
    case manager = "Manager"
    case marketing = "Marketing"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .dj: return "DJ"
        case .ds: return "DS"
        case .manager: return "经理"
        case .marketing: return "营销"
        }
    }
}

// MARK: - 统计周期枚举
enum StatPeriod: String, CaseIterable {
    case day = "日"
    case week = "周"
    case month = "月"

    var id: String { rawValue }
}

// MARK: - 排序选项
enum SortOption: String, CaseIterable {
    case byAmount = "金额"
    case byCount = "笔数"
    case byName = "姓名"
}
