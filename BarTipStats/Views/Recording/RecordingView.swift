import SwiftUI
import SwiftData

/// 记账首页（Tab 1）
struct RecordingView: View {
    @Environment(\.modelContext) private var context
    @State private var showManagement = false

    @Query(sort: \TipRecord.date, order: .reverse)
    private var allTips: [TipRecord]

    private var todayTips: [TipRecord] {
        allTips.filter { $0.date.isToday }
    }

    private var todayTotal: Double {
        todayTips.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 今日汇总
                    DailySummaryCard(
                        todayTotal: todayTotal,
                        recordCount: todayTips.count
                    )

                    // 录入表单
                    TipInputForm()

                    // 最近记录标题
                    if !todayTips.isEmpty {
                        HStack {
                            Text("今日记录")
                                .font(.headline.weight(.semibold))
                            Spacer()
                            Text("共 \(todayTips.count) 笔")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 4)

                        // 最近记录列表
                        LazyVStack(spacing: 0) {
                            ForEach(todayTips.prefix(20)) { record in
                                RecentTipRow(record: record)
                                if record.id != todayTips.prefix(20).last?.id {
                                    Divider()
                                        .padding(.leading, 58)
                                }
                            }
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                        }
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("小费记账")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showManagement = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.appAccent)
                    }
                }
            }
            .sheet(isPresented: $showManagement) {
                ManagementView()
            }
        }
    }
}

#Preview {
    RecordingView()
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
        .preferredColorScheme(.dark)
}
