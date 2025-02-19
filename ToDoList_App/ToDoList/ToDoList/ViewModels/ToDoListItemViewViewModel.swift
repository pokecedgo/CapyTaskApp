import Foundation
import FirebaseFirestore

class ToDoListItemViewViewModel: ObservableObject {
    private let userId: String

    init(userId: String) {
        self.userId = userId
    }

    func updateItemCompletionStatus(itemId: String, isCompleted: Bool, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let itemRef = db.collection("users/\(userId)/todos").document(itemId)
        
        itemRef.updateData(["isDone": isCompleted]) { error in
            if let error = error {
                print("Error updating completion status: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
}
