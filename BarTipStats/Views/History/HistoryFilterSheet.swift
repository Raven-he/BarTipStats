import SwiftUI
import SwiftData

/// 历史记录筛选弹窗
struct HistoryFilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedEmployee: Employee?
    @Binding var selectedVenue: Venue?
    @Binding var startDate: Date
    @Binding var endDate: Date

    @Query(
        filter: #Predicate<Employee> { $0.isActive == true },
        sort: \Employee.sortOrder
    ) private var employees: [Employee]

    @Query(
        filter: #Predicate<Venue> { $0.isActive == true },
        sort: \Venue.sortOrder
    ) private var venues: [Venue]

    var body: some View {
        NavigationStack {
            Form {
                // 日期范围
                Section("日期范围") {
                    DatePicker("开始日期", selection: $startDate, displayedComponents: .date)
                    DatePicker("结束日期", selection: $endDate, displayedComponents: .date)
                }

                // 员工筛选
                Section("按员工") {
                    Picker("选择员工", selection: $selectedEmployee) {
                        Text("全部").tag(nil as Employee?)
                        ForEach(employees) { employee in
                            Text(employee.name)
                                .tag(employee as Employee?)
                        }
                    }
                }

                // 场地筛选
                Section("按场地") {
                    Picker("选择场地", selection: $selectedVenue) {
                        Text("全部").tag(nil as Venue?)
                        ForEach(venues) { venue in
                            Text(venue.name)
                                .tag(venue as Venue?)
                        }
                    }
                }
            }
            .navigationTitle("筛选条件")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    HistoryFilterSheet(
        selectedEmployee: .constant(nil),
        selectedVenue: .constant(nil),
        startDate: .constant(Date().startOfMonth),
        endDate: .constant(Date())
    )
    .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
    .preferredColorScheme(.dark)
}
