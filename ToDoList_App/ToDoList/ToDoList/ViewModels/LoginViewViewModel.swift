import SwiftUI
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""

    private var currentNonce: String?

    init() {}

    func login() {
        guard validate() else {
            return
        }

        // Firebase Email/Password Authentication
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessage = "Login failed: \(error.localizedDescription)"
            } else {
                print("Login successful!")
            }
        }
    }


    private func validate() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }

        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email"
            return false
        }

        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters long"
            return false
        }

        return true
    }

   
}

