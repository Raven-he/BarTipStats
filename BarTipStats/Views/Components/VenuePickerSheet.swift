import SwiftUI
import SwiftData

/// 场地选择器（搜索式弹窗）
struct VenuePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: Venue?
    @State private var searchText = ""

    @Query(
        filter: #Predicate<Venue> { $0.isActive == true },
        sort: \Venue.sortOrder, order: .forward
    ) private var venues: [Venue]

    var filteredVenues: [Venue] {
        if searchText.isEmpty { return venues }
        return venues.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredVenues) { venue in
                    Button {
                        selection = venue
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "table.furniture.fill")
                                .foregroundStyle(.orange)
                                .font(.title3)

                            Text(venue.name)
                                .font(.body.weight(.semibold))

                            Spacer()

                            if selection?.id == venue.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.appAccent)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            .searchable(text: $searchText, prompt: "搜索卡座/散台")
            .navigationTitle("选择场地")
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
    VenuePickerSheet(selection: .constant(nil))
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
        .preferredColorScheme(.dark)
}
