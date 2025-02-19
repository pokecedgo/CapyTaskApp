import SwiftUI
import FirebaseFirestore
import Combine

class NewItemViewViewModel: ObservableObject {
    @Published var tasks: [ToDoListItem] = []   // Array to hold tasks
    @Published var isLoading: Bool = true        // Loading state to show a loading indicator
    @Published var showAlert: Bool = false
    @Published var title: String = ""
    @Published var dueDate: Date = Date()
    
    var canSave: Bool {
        !title.isEmpty && dueDate > Date() // Simple validation
    }
    
    private var db = Firestore.firestore()  // Reference to Firestore
    
    init() {
        fetchTasks()
    }
    
    // Fetch tasks from Firestore (replace with your actual data source)
    func fetchTasks() {
        // Firestore example
        db.collection("tasks")
            .order(by: "createdDate", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching tasks: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                
                if let snapshot = snapshot {
                    self.tasks = snapshot.documents.compactMap { document in
                        try? document.data(as: ToDoListItem.self)
                    }
                }
                
                self.isLoading = false
            }
    }
    
    // Save new task to Firestore (or your database)
    func save() {
        let newTask = ToDoListItem(
            id: UUID().uuidString,
            title: title,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            priority: "Normal" // Example priority, you can change this logic
        )
        
        do {
            _ = try db.collection("tasks").addDocument(from: newTask)
            print("Task saved")
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
    
    // Set title method
    func setTitle(_ newTitle: String) {
        title = newTitle
    }
}
