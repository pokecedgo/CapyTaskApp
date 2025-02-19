import SwiftUI
import AVFoundation

struct NewItemUIView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    @State private var selectedPriority: String = "Normal"
    @State private var isGlowing = false
    @State private var isSuggestionsPresented = false
    @State private var showingPrioritySheet = false // Flag for showing the action sheet

    var addItemAction: (ToDoListItem) -> Void

    var body: some View {
        ZStack {
            Color.white // Ensure the background is always white
                .ignoresSafeArea()

            VStack {
                // Header with Image and Title
                headerSection

                // Content Section
                VStack(alignment: .leading, spacing: 20) {
                    // Title Input with Suggestions Button
                    HStack {
                        TextField("Title", text: $viewModel.title)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .padding(.leading)

                        Spacer()

                        Button(action: {
                            isSuggestionsPresented = true
                        }) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 30))
                                .foregroundColor(.brown)
                        }
                    }
                    .padding()

                    // Date Picker
                    VStack(alignment: .leading, spacing: 5) {
                        DatePicker("", selection: $viewModel.dueDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden() // Hides the default label of the DatePicker
                    }
                    .padding()


                    // Priority Button Section
                    VStack(alignment: .leading) {
                        Text("Priority")
                            .font(.subheadline)
                            .padding(.bottom, 5)

                        Button(action: {
                            showingPrioritySheet = true
                        }) {
                            HStack {
                                Image(systemName: "note.text")
                                    .font(.system(size: 16))
                                Text(selectedPriority)
                                    .font(.system(size: 16))
                                    .bold()
                            }
                            .padding()
                            .frame(width: 365, height: 45) // Customizable size
                            .background(getPriorityColor(for: selectedPriority))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isGlowing)
                        .onAppear {
                            isGlowing = true // Start the glowing animation
                        }
                        .onDisappear {
                            isGlowing = false // Stop the glowing animation
                        }
                        .actionSheet(isPresented: $showingPrioritySheet) {
                            ActionSheet(
                                title: Text("Select Priority"),
                                message: Text("Please choose a priority for the task."),
                                buttons: [
                                    .default(Text("Low")) {
                                        selectedPriority = "Low"
                                        playClickSound()
                                    },
                                    .default(Text("Normal")) {
                                        selectedPriority = "Normal"
                                        playClickSound()
                                    },
                                    .default(Text("High")) {
                                        selectedPriority = "High"
                                        playClickSound()
                                    },
                                    .cancel()
                                ]
                            )
                        }
                    }

                    // Save Button
                    TLButton(
                        title: "Save",
                        background: Color.brown
                    ) {
                        if viewModel.canSave {
                            viewModel.save()

                            let newItem = ToDoListItem(
                                id: UUID().uuidString,
                                title: viewModel.title,
                                dueDate: viewModel.dueDate.timeIntervalSince1970,
                                createdDate: Date().timeIntervalSince1970,
                                isDone: false,
                                priority: selectedPriority
                            )
                            addItemAction(newItem)
                            newItemPresented = false
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                    .frame(width: 200, height: 40) // Smaller width for the Save button
                    .padding()
                    .frame(maxWidth: .infinity) // Center the Save button horizontally
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please fill out all fields and select a valid due date."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .sheet(isPresented: $isSuggestionsPresented) {
            PresetView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.fetchTasks() // Trigger fetching tasks on view appearance
        }
    }

    // Header Section with Image and Title
    private var headerSection: some View {
        VStack {
            Image("Capybara")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)

            Text("New Item")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.brown)
                .padding(.top, 10)
        }
        .padding()
    }

    // Play sound when priority button is clicked
    private func playClickSound() {
        AudioHandler.shared.playSound(named: "click", withExtension: "wav")
    }

    // Function to return color based on priority
    private func getPriorityColor(for priority: String) -> Color {
        switch priority {
        case "Low":
            return Color.gray
        case "Normal":
            return Color.orange
        case "High":
            return Color.red
        default:
            return Color.gray
        }
    }
}

// Preview code
#Preview {
    NewItemUIView(newItemPresented: .constant(true), addItemAction: { newItem in
        // Dummy action for preview purposes
        print("New item added: \(newItem.title)")
    })
}
