import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @StateObject var viewModel: ToDoListViewViewModel

    @State private var isLoggedOut = false
    @State private var showingDeleteConfirmation = false

    init(userId: String) {
        _viewModel = StateObject(wrappedValue: ToDoListViewViewModel())
    }


    
    var body: some View {
        NavigationView {
            VStack {
                // Image at the top
                Image("Capy_Main")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 30)

                // User information
                if let user = viewModel.user {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Name: \(user.name.capitalized)") // Display the user's name here
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Email: \(user.email)") // Display the user's email
                            .font(.title3)

                        Text("Join Date: \(Date(timeIntervalSince1970: user.joined), style: .date)") // Display the join date
                            .font(.title2)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                } else {
                    Text("Loading user data...")
                        .padding()
                }

                Spacer()

                // Title with gradient color
                VStack {
                    Text("CapyTask")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.brown, Color.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("Created by Ced 🧸 @Capybara4Life")
                        .font(.subheadline)
                }

                // Button Layout with Sign Out and Delete Account side by side
                HStack(spacing: 5) {
                    // Sign Out Button
                    Button(action: {
                        signOutUser()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.brown)
                            .cornerRadius(10)
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                    }

                    // Delete Account Button
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.brown.opacity(0.8))
                            .cornerRadius(10)
                            .offset(x: -25)
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 30)

                // Alert for Delete Confirmation
                .alert(isPresented: $showingDeleteConfirmation) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("This action is permanent and will delete your account."),
                        primaryButton: .destructive(Text("Yes"), action: {
                            deleteAccount()
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationTitle("Account")
        }
        .onAppear {
            // Play the CapySong.mp3 when the view appears
            AudioHandler.shared.playSound(named: "CapySong", withExtension: "mp3")
        }
        .fullScreenCover(isPresented: $isLoggedOut, content: {
            LoginView() // Navigate to LoginView when signed out
        })
    }

    // Sign out user
    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true // Set flag to show LoginView
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    // Delete user account
    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }

        // Optionally, delete user data from Firestore or other backend
        deleteUserDataFromFirestore()

        // Now delete the account from Firebase Authentication
        user.delete { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
            } else {
                print("Account deleted successfully.")
                isLoggedOut = true // Navigate to login screen after account is deleted
            }
        }
    }

    // Optionally delete user data from Firestore (if you're storing any)
    private func deleteUserDataFromFirestore() {
        let db = Firestore.firestore()
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").document(userId).delete() { error in
                if let error = error {
                    print("Error deleting user data from Firestore: \(error.localizedDescription)")
                } else {
                    print("User data deleted from Firestore.")
                }
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userId: "sampleUserId") // Provide a sample user ID to initialize ProfileView
            .previewDevice("iPhone 16") // Choose a device for the preview
    }
}
