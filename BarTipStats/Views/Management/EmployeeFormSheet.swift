import SwiftUI
import SwiftData

/// 添加/编辑员工表单
struct EmployeeFormSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let editEmployee: Employee?

    @State private var name: String = ""
    @State private var selectedPosition: Position = .dj

    private var isEditing: Bool { editEmployee != nil }
    private var isFormValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    init(editEmployee: Employee? = nil) {
        self.editEmployee = editEmployee
        if let emp = editEmployee {
            _name = State(initialValue: emp.name)
            _selectedPosition = State(initialValue: emp.position)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    TextField("员工姓名", text: $name)
                        .autocorrectionDisabled()

                    Picker("岗位", selection: $selectedPosition) {
                        ForEach(Position.allCases) { position in
                            HStack {
                                Image(systemName: positionIcon(position))
                                    .foregroundStyle(.appAccent)
                                Text(position.displayName)
                            }
                            .tag(position)
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "编辑员工" : "添加员工")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "保存" : "添加") {
                        save()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }

    private func save() {
        guard isFormValid else { return }
        if let emp = editEmployee {
            emp.name = name.trimmingCharacters(in: .whitespaces)
            emp.position = selectedPosition
        } else {
            let maxOrder = (try? context.fetch(
                FetchDescriptor<Employee>(sortBy: [SortDescriptor(\.sortOrder, order: .reverse)])
            ).first?.sortOrder ?? -1) + 1
            let emp = Employee(name: name.trimmingCharacters(in: .whitespaces),
                              position: selectedPosition,
                              sortOrder: maxOrder)
            context.insert(emp)
        }
        dismiss()
    }

    private func positionIcon(_ position: Position) -> String {
        switch position {
        case .dj: return "music.note.list"
        case .ds: return "person.wave.2"
        case .manager: return "person.badge.key"
        case .marketing: return "megaphone.fill"
        }
    }
}

#Preview {
    EmployeeFormSheet()
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
        .preferredColorScheme(.dark)
}
