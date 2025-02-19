import Foundation
import FirebaseAuth

class ProfileViewViewModel: ObservableObject {
    @Published var userName: String = "Cedric Steve" // Default or mock data
    @Published var userEmail: String = "cedric@example.com" // Mock user email
    @Published var joinDate: String = "January 1, 2022" // Mock join date

  /*  init() {
        // Observe Firebase Auth state change
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.userName = user.displayName?.capitalized ?? "No Name Available"
                self?.userEmail = user.email ?? "No email available"
                if let creationDate = user.metadata.creationDate {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .long
                    formatter.timeStyle = .none
                    self?.joinDate = formatter.string(from: creationDate)
                }
            }
        }
    } */
}
