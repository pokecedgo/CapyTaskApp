import Foundation

struct ToDoListItem: Identifiable, Codable {
    var id: String
    var title: String
    var dueDate: TimeInterval
    var createdDate: TimeInterval
    var isDone: Bool
    var priority: String
}
