import SwiftUI
import SwiftData

/// 员工管理列表
struct EmployeeListView: View {
    @Environment(\.modelContext) private var context
    @State private var showAddSheet = false
    @State private var editEmployee: Employee? = nil

    @Query(sort: \Employee.sortOrder, order: .forward)
    private var employees: [Employee]

    var body: some View {
        List {
            if employees.isEmpty {
                ContentUnavailableView(
                    "暂无员工",
                    systemImage: "person.2.slash",
                    description: Text("点击右上角 + 添加员工")
                )
            } else {
                ForEach(employees) { employee in
                    Button {
                        editEmployee = employee
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(.appAccent.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                Text(employee.name.prefix(1))
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(.appAccent)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(employee.name)
                                    .font(.body.weight(.medium))
                                Text(employee.position.displayName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(.gray.opacity(0.15))
                                    .clipShape(Capsule())
                            }

                            Spacer()

                            Text("\(employee.tips.count) 笔")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .foregroundStyle(.primary)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let emp = employees[index]
                        emp.isActive = false
                    }
                }
            }
        }
        .navigationTitle("员工管理")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.appAccent)
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            EmployeeFormSheet()
        }
        .sheet(item: $editEmployee) { employee in
            EmployeeFormSheet(editEmployee: employee)
        }
    }
}

#Preview {
    NavigationStack {
        EmployeeListView()
    }
    .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
    .preferredColorScheme(.dark)
}
