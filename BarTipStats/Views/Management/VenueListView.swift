import SwiftUI
import SwiftData

/// 场地管理列表
struct VenueListView: View {
    @Environment(\.modelContext) private var context
    @State private var showAddSheet = false
    @State private var editVenue: Venue? = nil

    @Query(sort: \Venue.sortOrder, order: .forward)
    private var venues: [Venue]

    var body: some View {
        List {
            if venues.isEmpty {
                ContentUnavailableView(
                    "暂无场地",
                    systemImage: "table.furniture",
                    description: Text("点击右上角 + 添加卡座或散台")
                )
            } else {
                ForEach(venues) { venue in
                    Button {
                        editVenue = venue
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "table.furniture.fill")
                                .font(.title3)
                                .foregroundStyle(.orange)
                                .frame(width: 40)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(venue.name)
                                    .font(.body.weight(.medium))
                                Text("\(venue.tips.count) 笔记录")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .foregroundStyle(.primary)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let venue = venues[index]
                        venue.isActive = false // 软删除
                    }
                }
            }
        }
        .navigationTitle("场地管理")
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
            VenueFormSheet()
        }
        .sheet(item: $editVenue) { venue in
            VenueFormSheet(editVenue: venue)
        }
    }
}

extension Venue: @retroactive Identifiable {}

#Preview {
    NavigationStack {
        VenueListView()
    }
    .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
    .preferredColorScheme(.dark)
}
