import Foundation
import SwiftData

enum AppContainer {
    static func create() -> ModelContainer {
        let schema = Schema([
            Employee.self,
            Venue.self,
            TipRecord.self
        ])

        // 本地存储（后续可开启 CloudKit）
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .none
        )

        return try! ModelContainer(for: schema, configurations: config)
    }
}
