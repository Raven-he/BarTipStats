import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: Tab = .recording

    enum Tab: String, CaseIterable {
        case recording = "记账"
        case statistics = "统计"
        case rankings = "排名"
        case history = "历史"

        var icon: String {
            switch self {
            case .recording: return "dollarsign.circle.fill"
            case .statistics: return "chart.bar.fill"
            case .rankings: return "trophy.fill"
            case .history: return "clock.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            RecordingView()
                .tabItem {
                    Label(Tab.recording.rawValue,
                          systemImage: Tab.recording.icon)
                }
                .tag(Tab.recording)

            StatisticsView()
                .tabItem {
                    Label(Tab.statistics.rawValue,
                          systemImage: Tab.statistics.icon)
                }
                .tag(Tab.statistics)

            RankingsView()
                .tabItem {
                    Label(Tab.rankings.rawValue,
                          systemImage: Tab.rankings.icon)
                }
                .tag(Tab.rankings)

            HistoryView()
                .tabItem {
                    Label(Tab.history.rawValue,
                          systemImage: Tab.history.icon)
                }
                .tag(Tab.history)
        }
        .tint(.appAccent)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
}
