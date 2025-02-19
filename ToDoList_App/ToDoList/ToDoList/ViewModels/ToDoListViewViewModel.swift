import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

class ToDoListViewViewModel: ObservableObject {
    @Published var currentUserId: String?
    @Published var items: [ToDoListItem] = []
    @Published var user: User?
    @Published var showingNewItemView: Bool = false  // Ensure this is published

    private var dataManager = DataManager.shared
    private var cancellables: Set<AnyCancellable> = []

    // Updated init method to fetch user ID from Firebase Auth
    init() {
        // Try to fetch the current user ID from Firebase Authentication
        if let userId = Auth.auth().currentUser?.uid {
            self.currentUserId = userId
        } else {
            print("Error: User ID is missing")
            return
        }

        // Subscribe to toDoItems and user data from DataManager
        dataManager.$toDoItems
            .sink { [weak self] items in
                self?.items = items
                // Fetch data if toDoItems is empty after subscription
                if self?.items.isEmpty == true, let userId = self?.currentUserId {
                    self?.dataManager.fetchToDoItems(userId: userId) { success in
                        if success {
                            print("Successfully fetched ToDo items.")
                        } else {
                            print("Failed to fetch ToDo items.")
                        }
                    }
                }
            }
            .store(in: &cancellables)

        dataManager.$user
            .sink { [weak self] user in
                self?.user = user
                // Fetch user data if user is nil after subscription
                if self?.user == nil, let userId = self?.currentUserId {
                    self?.dataManager.fetchUserData(userId: userId)
                }
            }
            .store(in: &cancellables)

        // Initial check if toDoItems is already fetched and not empty
        if dataManager.toDoItems.isEmpty, let userId = currentUserId {
            dataManager.fetchToDoItems(userId: userId) { success in
                if success {
                    print("Successfully fetched ToDo items initially.")
                } else {
                    print("Failed to fetch ToDo items initially.")
                }
            }
        }

        // Initial check if user data is already fetched
        if dataManager.user == nil, let userId = currentUserId {
            dataManager.fetchUserData(userId: userId)
        }
    }

    // Add new item to ToDo list
    func addItem(_ item: ToDoListItem) {
        dataManager.addToDoItem(item)
    }

    // Update item in ToDo list
    func updateItem(_ item: ToDoListItem) {
        dataManager.updateToDoItem(item)
    }

    // Update the completion status of an item
    func updateCompletionStatus(for id: String, isCompleted: Bool) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].isDone = isCompleted
            updateItem(items[index])
        }
    }
}
