import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewViewModel
    @State private var isLoading = true
    @State private var selectedTab = "Today"
    
    init(userId: String?) {
        _viewModel = StateObject(wrappedValue: ToDoListViewViewModel())
    }

    var body: some View {
        NavigationView {
            ZStack {
                // PreloadView: Show when loading
                if isLoading {
                    PreloadView(isLoading: $isLoading) // Show PreloadView when loading
                        .zIndex(1) // Make sure it's on top
                }

                // Main content when not loading
                VStack {
                    // Header View
                    headerView

                    // Tab Picker
                    Picker("", selection: $selectedTab) {
                        Text("Today").tag("Today")
                        Text("Upcoming").tag("Upcoming")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: selectedTab) { _ in
                        // Play the transition sound on tab change
                        AudioHandler.shared.playSound(named: "transition", withExtension: "wav")
                    }

                    // Task List
                    if isLoading {
                        Text("Loading tasks...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ZStack {
                            // Transparent Background for the List view
                            Color.clear.edgesIgnoringSafeArea(.all)

                            List {
                                if selectedTab == "Today" {
                                    LazyVStack {
                                        ForEach(todayItems, id: \.id) { item in
                                            if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                                                ToDoItemRow(
                                                    item: $viewModel.items[index],
                                                    itemViewModel: ToDoListItemViewViewModel(userId: viewModel.user?.id ?? ""),
                                                    viewModel: viewModel,
                                                    onStatusChange: {
                                                        viewModel.updateCompletionStatus(for: item.id, isCompleted: viewModel.items[index].isDone)
                                                    }
                                                )
                                            }
                                        }
                                    }
                                } else {
                                    LazyVStack {
                                        ForEach(upcomingItems, id: \.id) { item in
                                            if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                                                ToDoItemRow(
                                                    item: $viewModel.items[index],
                                                    itemViewModel: ToDoListItemViewViewModel(userId: viewModel.user?.id ?? ""),
                                                    viewModel: viewModel,
                                                    onStatusChange: {
                                                        viewModel.updateCompletionStatus(for: item.id, isCompleted: viewModel.items[index].isDone)
                                                    }
                                                )
                                            }
                                        }
                                    }
                                }

                                // Always add "Add Task" button at the bottom
                                addTaskButton
                                    .padding(.top, 10)
                            }
                            .listStyle(PlainListStyle())
                            .background(Color(UIColor.white)) // Set the background of the List to white
                        }
                    }

                    Spacer()

                    // Progress Bar
                    progressBarView
                }
                .navigationTitle(selectedTab)
                .navigationBarItems(trailing: addButton)
                .navigationBarHidden(isLoading) // Hide navigation bar when loading
            }
            .onAppear {
                loadDataIfNeeded()
            }
            .sheet(isPresented: Binding(get: { viewModel.showingNewItemView },
                                        set: { viewModel.showingNewItemView = $0 })) {
                newItemSheetView
            }
            .preferredColorScheme(.light) // Force light mode
        }
    }
    
    private func loadDataIfNeeded() {
        // Ensure userId is set
        guard let userId = viewModel.currentUserId else {
            print("User ID is missing")
            return
        }

        isLoading = true

        // Fetch to-do items asynchronously
        DataManager.shared.fetchToDoItems(userId: userId) { _ in
            // This callback will be called after fetching data from Firestore
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    // MARK: - Views

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white,
                Color.white
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }

    private var headerView: some View {
        HStack {
            Image("Capybara_Sleep") // Example image asset
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .padding(.leading, 8)

            VStack(alignment: .leading) {
                Text("Hello, \(viewModel.user?.name.capitalized ?? "User")") // Capitalized user name
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("Today you have \(todayItems.count) tasks")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
    }

    private var addButton: some View {
        Button(action: {
            viewModel.showingNewItemView = true  // Set the value directly
        }) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.pink)
        }
    }

    private var addTaskButton: some View {
        Button(action: {
            viewModel.showingNewItemView = true
        }) {
            HStack {
                Spacer()
                Text("+ Add Task")
                    .fontWeight(.medium)
                    .foregroundColor(.pink)
                    .padding()
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white).shadow(radius: 5))
        }
    }

    private var newItemSheetView: some View {
        NewItemUIView(
            newItemPresented: $viewModel.showingNewItemView,  // Correct binding
            addItemAction: { newItem in
                var newItem = newItem
                newItem.isDone = false
                DataManager.shared.addToDoItem(newItem) // Save item via DataManager
            }
        )
    }

    private var progressBarView: some View {
        HStack {
            Image("Capybara_Sleep") // Example image asset for progress bar
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(.trailing, -5)

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.brown.opacity(0.6))
                    .frame(width: 150, height: 20)
                    .shadow(radius: 10)

                ProgressView(value: calculateProgress())
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 242 / 255, green: 160 / 255, blue: 88 / 255)))
                    .frame(width: 140, height: 10)
                    .scaleEffect(y: 1.5, anchor: .center)
                    .cornerRadius(5)
            }
            .padding()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    // Sorting Methods
    private var todayItems: [ToDoListItem] {
        viewModel.items.filter { isToday($0.dueDate) || isPastDue($0.dueDate) }
            .sorted(by: {
                priorityOrder($0.priority) < priorityOrder($1.priority) || $0.dueDate < $1.dueDate
            })
    }

    private var upcomingItems: [ToDoListItem] {
        viewModel.items.filter { isUpcoming($0.dueDate) }
            .sorted(by: { $0.dueDate < $1.dueDate })
    }

    private func priorityOrder(_ priority: String) -> Int {
        switch priority {
        case "High": return 0
        case "Normal": return 1
        case "Low": return 2
        default: return 3
        }
    }

    private func isToday(_ dueDate: TimeInterval) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let itemDate = Date(timeIntervalSince1970: dueDate)
        return Calendar.current.isDate(itemDate, inSameDayAs: today)
    }

    private func isPastDue(_ dueDate: TimeInterval) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let itemDate = Date(timeIntervalSince1970: dueDate)
        return itemDate < today
    }

    private func isUpcoming(_ dueDate: TimeInterval) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let itemDate = Date(timeIntervalSince1970: dueDate)
        return itemDate >= tomorrow // Only include tasks due tomorrow or later
    }

    private func calculateProgress() -> Double {
        let totalCount = viewModel.items.count
        let completedCount = viewModel.items.filter { $0.isDone }.count
        return totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
    }
}

// Preview
#Preview {
    ToDoListView(userId: "mockUserId") // Use a mock value or an actual user ID if available
}
