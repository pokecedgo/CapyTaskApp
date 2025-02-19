import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()

    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            // Pass the userId from the viewModel to ToDoListView
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
            
            // Pass the userId from the viewModel to ProfileView
            ProfileView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Account", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView() // Now preview should work with correct `userId`
}
