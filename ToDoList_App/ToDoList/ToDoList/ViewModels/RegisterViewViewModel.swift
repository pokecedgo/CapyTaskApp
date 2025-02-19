//
//  RegisterViewViewModel.swift
//  ToDoList
//
//  Created by Cedric Petilos on 12/25/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation



class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    
    init() {}
    
    
    func register() {
        guard validate() else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let userId = result?.user.uid else {
                return
            }
            
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String) {
        // Prepare user data
        let newUser = [
            "id": id,
            "name": name,
            "email": email,
            "joined": Date().timeIntervalSince1970
        ] as [String: Any]
        
        // Reference to Firestore
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser) { error in
                if let error = error {
                    print("Error saving user record: \(error.localizedDescription)")
                } else {
                    print("User record saved successfully.")
                }
            }
    }

    
    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            return false
        }
        
        
        guard password.count >= 8 else {
            return false
        }
        
        return true
    }
}
