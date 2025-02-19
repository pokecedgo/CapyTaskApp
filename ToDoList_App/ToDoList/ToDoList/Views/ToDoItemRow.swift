import SwiftUI

struct ToDoItemRow: View {
    @Binding var item: ToDoListItem
    @ObservedObject var itemViewModel: ToDoListItemViewViewModel
    @ObservedObject var viewModel: ToDoListViewViewModel
    var onStatusChange: () -> Void

    @State private var localIsDone: Bool

    init(item: Binding<ToDoListItem>, itemViewModel: ToDoListItemViewViewModel, viewModel: ToDoListViewViewModel, onStatusChange: @escaping () -> Void) {
           _item = item
           self.itemViewModel = itemViewModel
           self.viewModel = viewModel
           self.onStatusChange = onStatusChange
           _localIsDone = State(initialValue: item.wrappedValue.isDone)
    }
    
    var body: some View {
        HStack {
            Menu {
                Button("Delete", role: .destructive) {
                    // Directly call DataManager to delete item
                   guard let userId = viewModel.currentUserId else {
                       print("Error: User ID is missing")
                       return
                   }

                   DataManager.shared.deleteToDoItem(item.id, userId: userId) { success in
                       if success {
                           // On successful deletion, remove the item from the local list
                           if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                               viewModel.items.remove(at: index)
                               print("Successfully deleted ToDo item with ID: \(item.id)")
                           }
                       } else {
                           print("Failed to delete ToDo item with ID: \(item.id)")
                       }
                   }
                   //sound
                    AudioHandler.shared.playSound(named: "click", withExtension: "wav")
                    onStatusChange() // Trigger any status change after deletion
                }
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(trashCanColor(for: item.priority)) // Use item.priority directly
            }
            .padding(.leading, 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(Color.black)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(.dateTime.month(.abbreviated).day().year().hour().minute()))")
                        .foregroundColor(item.dueDate < Date().timeIntervalSince1970 ? .red : .gray)
                        .font(.subheadline)
                    Image(systemName: "clock")
                        .foregroundColor(item.dueDate < Date().timeIntervalSince1970 ? .red : .gray)
                }
            }
            .padding(.leading, 5)
            .padding(.trailing, 2)

            Spacer()

            Button(action: {
                localIsDone.toggle()
                itemViewModel.updateItemCompletionStatus(itemId: item.id, isCompleted: localIsDone) { success in
                    if success {
                        //sound
                        AudioHandler.shared.playSound(named: "click", withExtension: "wav")
                        item.isDone = localIsDone
                        onStatusChange()
                    }
                }
            }) {
                Image(systemName: localIsDone ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(localIsDone ? .brown : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.brown.opacity(0.5), radius: 5, x: 0, y: 0)
    }

    private func trashCanColor(for priority: String) -> Color {
        switch priority {
        case "Low": return .gray
        case "High": return .red
        default: return .orange
        }
    }
}


struct ToDoItemRow_Previews: PreviewProvider {
    static var previews: some View {
        // Mock data for preview with priority added
        let mockItem = ToDoListItem(
            id: UUID().uuidString,
            title: "Go to the house",
            dueDate: Date().timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            priority: "High" // Add priority here for the preview
        )

        // Creating mock ViewModels
        let mockViewModel = ToDoListItemViewViewModel(userId: "MockUserId")
        let parentViewModel = ToDoListViewViewModel() 
        // Return the ToDoItemRow with mock data and all required parameters
        ToDoItemRow(
            item: .constant(mockItem), // Use .constant to pass Binding<ToDoListItem>
            itemViewModel: mockViewModel, // Provide a mock ItemViewModel
            viewModel: parentViewModel, // Provide a mock parent ViewModel
            onStatusChange: {
                // Provide a simple closure for preview purposes
                print("Status changed in preview")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
