import SwiftUI
import SwiftData

/// 员工选择器（搜索式弹窗）
struct EmployeePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: Employee?
    @State private var searchText = ""

    @Query(
        filter: #Predicate<Employee> { $0.isActive == true },
        sort: \Employee.sortOrder, order: .forward
    ) private var employees: [Employee]

    var filteredEmployees: [Employee] {
        if searchText.isEmpty { return employees }
        return employees.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredEmployees) { employee in
                    Button {
                        selection = employee
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(employee.name)
                                    .font(.body.weight(.semibold))
                                Text(employee.position.displayName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if selection?.id == employee.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.appAccent)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            .searchable(text: $searchText, prompt: "搜索员工姓名")
            .navigationTitle("选择员工")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EmployeePickerSheet(selection: .constant(nil))
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
        .preferredColorScheme(.dark)
}
