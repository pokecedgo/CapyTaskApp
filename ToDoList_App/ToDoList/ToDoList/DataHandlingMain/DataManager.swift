import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager() // Singleton for global access
    
    @Published var user: User?
    @Published var toDoItems: [ToDoListItem] = []
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        // Enabling Firestore offline persistence
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
    }

    // MARK: - User Management

    // Fetch user data for a specific userId with caching and background processing
    func fetchUserData(userId: String) {
        // Check if data is already cached
        if let cachedUser = self.user {
            print("User data cached: \(cachedUser)")
            return
        }
        
        // Fetch from Firestore if not cached
        DispatchQueue.global(qos: .background).async {
            self.db.collection("users").document(userId).getDocument { document, error in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }
                
                if let document = document, document.exists {
                    do {
                        let userData = try document.data(as: User.self)
                        DispatchQueue.main.async {
                            self.user = userData
                        }
                    } catch {
                        print("Error decoding user data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // Save user data to Firestore
    func saveUserData(_ user: User) {
        guard let currentUser = auth.currentUser else { return }
        let userId = currentUser.uid
        
        do {
            try db.collection("users").document(userId).setData(from: user)
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }

    // MARK: - ToDo Management

    // Fetch to-do items for a specific userId with caching, batching, and background processing
    func fetchToDoItems(userId: String, completion: @escaping (Bool) -> Void) {
        // Check if data is already cached
        if !self.toDoItems.isEmpty {
            print("To-Do items cached")
            completion(true) // Return cached data
            return
        }
        
        // Fetch from Firestore if not cached
        DispatchQueue.global(qos: .background).async {
            self.db.collection("users").document(userId).collection("todos")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching to-do items: \(error.localizedDescription)")
                        completion(false) // Indicate failure
                        return
                    }

                    DispatchQueue.main.async {
                        self.toDoItems = snapshot?.documents.compactMap { document in
                            try? document.data(as: ToDoListItem.self)
                        } ?? []
                        completion(true) // Indicate success
                    }
                }
        }
    }

    // Add a new to-do item
    func addToDoItem(_ item: ToDoListItem) {
        guard let currentUser = auth.currentUser else { return }
        let userId = currentUser.uid
        
        do {
            try db.collection("users").document(userId).collection("todos").document(item.id).setData(from: item)
            DispatchQueue.main.async {
                self.toDoItems.append(item) // Update local state after successful addition
            }
        } catch {
            print("Error adding to-do item: \(error.localizedDescription)")
        }
    }

    // Update an existing to-do item
    func updateToDoItem(_ item: ToDoListItem) {
        guard let currentUser = auth.currentUser else { return }
        let userId = currentUser.uid
        
        do {
            try db.collection("users").document(userId).collection("todos").document(item.id).setData(from: item)
        } catch {
            print("Error updating to-do item: \(error.localizedDescription)")
        }
    }

    // Delete a to-do item from Firestore with retry logic
    func deleteToDoItem(_ id: String, userId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        // Function to attempt deletion and verify the item
        func attemptDelete(retryCount: Int) {
            db.collection("users").document(userId).collection("todos").document(id).delete { error in
                if let error = error {
                    print("Error deleting item: \(error.localizedDescription)")
                    completion(false) // Deletion failed
                    return
                }

                // Check if the item still exists after deletion
                db.collection("users").document(userId).collection("todos").document(id).getDocument { document, error in
                    if let error = error {
                        print("Error checking item existence: \(error.localizedDescription)")
                        completion(false)
                        return
                    }

                    if document?.exists == true {
                        print("Item still exists, retrying deletion... Retry count: \(retryCount)")

                        // If the item still exists and retry count is less than 3, retry
                        if retryCount < 3 {
                            attemptDelete(retryCount: retryCount + 1)
                        } else {
                            print("Failed to delete item after 3 attempts.")
                            completion(false) // Max retries reached
                        }
                    } else {
                        print("Item successfully deleted.")
                        completion(true) // Item deleted successfully
                    }
                }
            }
        }

        // Initial deletion attempt
        attemptDelete(retryCount: 0)
    }


    // MARK: - Efficient Querying
    
    // Use indexing for querying large collections
    func fetchToDoItemsWithFilter(userId: String, filter: String, completion: @escaping () -> Void) {
        // Ensure that Firestore is properly indexed for this query
        db.collection("users").document(userId).collection("todos")
            .whereField("status", isEqualTo: filter)  // Example filter on 'status'
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching filtered to-do items: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.toDoItems = snapshot?.documents.compactMap { document in
                        try? document.data(as: ToDoListItem.self)
                    } ?? []
                    completion()  // Call completion handler after fetching data
                }
            }
    }
}
