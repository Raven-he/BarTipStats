import Foundation
import SwiftData

@Model
final class Employee {
    var id: UUID = UUID()
    var name: String = ""
    var positionRaw: String = Position.dj.rawValue
    var isActive: Bool = true
    var sortOrder: Int = 0
    var createdAt: Date = Date()

    @Relationship(deleteRule: .cascade, inverse: \TipRecord.employee)
    var tips: [TipRecord] = []

    var position: Position {
        get { Position(rawValue: positionRaw) ?? .dj }
        set { positionRaw = newValue.rawValue }
    }

    init(name: String, position: Position, sortOrder: Int = 0) {
        self.name = name
        self.positionRaw = position.rawValue
        self.sortOrder = sortOrder
    }
}
