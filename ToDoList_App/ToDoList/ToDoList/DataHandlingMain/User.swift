import Foundation

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
