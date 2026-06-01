import Foundation
import SwiftData

@Model
final class TipRecord {
    var id: UUID = UUID()
    var amount: Double = 0.0
    var date: Date = Date()
    var note: String = ""
    var createdAt: Date = Date()

    @Relationship(inverse: \Employee.tips)
    var employee: Employee?

    @Relationship(inverse: \Venue.tips)
    var venue: Venue?

    init(
        amount: Double,
        employee: Employee,
        venue: Venue,
        date: Date = Date(),
        note: String = ""
    ) {
        self.amount = amount
        self.employee = employee
        self.venue = venue
        self.date = date
        self.note = note
    }
}
