import SwiftUI
import SwiftData

/// 添加/编辑场地表单
struct VenueFormSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let editVenue: Venue?

    @State private var name: String = ""

    private var isEditing: Bool { editVenue != nil }
    private var isFormValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    init(editVenue: Venue? = nil) {
        self.editVenue = editVenue
        if let venue = editVenue {
            _name = State(initialValue: venue.name)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("场地信息") {
                    TextField("场地名称（如：卡座888、散台A区）", text: $name)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle(isEditing ? "编辑场地" : "添加场地")
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
        if let venue = editVenue {
            venue.name = name.trimmingCharacters(in: .whitespaces)
        } else {
            let maxOrder = (try? context.fetch(
                FetchDescriptor<Venue>(sortBy: [SortDescriptor(\.sortOrder, order: .reverse)])
            ).first?.sortOrder ?? -1) + 1
            let venue = Venue(name: name.trimmingCharacters(in: .whitespaces),
                             sortOrder: maxOrder)
            context.insert(venue)
        }
        dismiss()
    }
}

#Preview {
    VenueFormSheet()
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
        .preferredColorScheme(.dark)
}
