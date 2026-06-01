import Foundation

extension Date {
    /// 当天 00:00:00
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// 当周周一 00:00:00
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }

    /// 当月 1 号 00:00:00
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }

    /// 日期格式化（月/日）
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: self)
    }

    /// 日期时间格式化
    var fullDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: self)
    }

    /// 精确时间格式化（时分秒）
    var preciseTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: self)
    }

    /// 判断是否在今天
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// 判断是否在本周
    var isThisWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 判断是否在本月
    var isThisMonth: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
}
