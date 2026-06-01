import SwiftUI
import SwiftData

@main
struct BarTipStatsApp: App {
    let container: ModelContainer

    init() {
        container = AppContainer.create()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}
