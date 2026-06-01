import SwiftUI
import SwiftData

/// 历史记录页（Tab 4）
struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @State private var searchText = ""
    @State private var showFilter = false

    // 筛选状态
    @State private var filterEmployee: Employee? = nil
    @State private var filterVenue: Venue? = nil
    @State private var filterStartDate: Date = Date().startOfMonth
    @State private var filterEndDate: Date = Date()

    @Query(sort: \TipRecord.date, order: .reverse)
    private var allTips: [TipRecord]

    private var filteredTips: [TipRecord] {
        var result = allTips

        // 搜索文本（按员工姓名）
        if !searchText.isEmpty {
            result = result.filter {
                $0.employee?.name.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }

        // 员工筛选
        if let emp = filterEmployee {
            result = result.filter { $0.employee?.id == emp.id }
        }

        // 场地筛选
        if let ven = filterVenue {
            result = result.filter { $0.venue?.id == ven.id }
        }

        // 日期范围
        result = result.filter { $0.date >= filterStartDate && $0.date <= filterEndDate }

        return result
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if filteredTips.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "clock.arrow.circlepath",
                        title: "暂无记录",
                        message: searchText.isEmpty ? "还没有小费记录" : "没有匹配的记录"
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(filteredTips) { record in
                            HistoryRow(record: record)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                context.delete(filteredTips[index])
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("历史记录")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "搜索员工姓名")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            showFilter = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle\(hasActiveFilter ? ".fill" : "")")
                                .foregroundStyle(hasActiveFilter ? .appAccent : .gray)
                        }

                        if !allTips.isEmpty {
                            EditButton()
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .sheet(isPresented: $showFilter) {
                HistoryFilterSheet(
                    selectedEmployee: $filterEmployee,
                    selectedVenue: $filterVenue,
                    startDate: $filterStartDate,
                    endDate: $filterEndDate
                )
            }
        }
    }

    private var hasActiveFilter: Bool {
        filterEmployee != nil || filterVenue != nil
            || filterStartDate != Date().startOfMonth
            || filterEndDate != Date()
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
        .preferredColorScheme(.dark)
}
