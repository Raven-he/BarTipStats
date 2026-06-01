import Foundation
import SwiftData

@Model
final class Venue {
    var id: UUID = UUID()
    var name: String = ""
    var isActive: Bool = true
    var sortOrder: Int = 0
    var createdAt: Date = Date()

    @Relationship(deleteRule: .cascade, inverse: \TipRecord.venue)
    var tips: [TipRecord] = []

    init(name: String, sortOrder: Int = 0) {
        self.name = name
        self.sortOrder = sortOrder
    }
}
