import Foundation
import SwiftData

enum AppContainer {
    static func create() -> ModelContainer {
        let schema = Schema([
            Employee.self,
            Venue.self,
            TipRecord.self
        ])

        // 本地存储配置
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .private("iCloud.com.bartipstats.app")
        )

        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            // CloudKit 配置失败时回退到仅本地存储
            let localConfig = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .none
            )
            return try! ModelContainer(for: schema, configurations: localConfig)
        }
    }
}
