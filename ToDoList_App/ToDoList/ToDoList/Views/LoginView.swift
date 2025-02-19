import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    // Customizable size properties for the login button
    @State private var buttonWidth: CGFloat = 300 // Default width
    @State private var buttonHeight: CGFloat = 50 // Default height

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(angle: 15,
                           background: .brown,
                           image: Image("Capy_Main"),
                           icon_angle: 13.5)

                ZStack {
                    VStack {
                        // Title with gradient color
                        Text("CapyTask")
                            .font(.system(size: 48, weight: .bold, design: .rounded)) // Cool font
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.brown, Color.white],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(y: -85)

                        // Subtitle
                        Text("Organize Your Life Today")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .offset(y: -80) // Adjusted for alignment with title
                    }
                }

                // Login Form (replaced Form with VStack)
                VStack(spacing: 20) {
                    // Show error message if exists
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                    }

                    TextField("Email: ", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)

                    SecureField("Password: ", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Customizable Login Button using SwiftUI's standard Button
                    Button(action: {
                        viewModel.login()
                    }) {
                        Text("Log In")
                            .frame(width: buttonWidth, height: buttonHeight) // Apply customizable size
                            .foregroundColor(.white)
                            .background(Color.brown)
                            .cornerRadius(10)
                            .font(.headline)
                    }
                    .padding(.bottom, 20)
                }
                .padding()

                // Create Account Section
                VStack {
                    Text("New around here?")
                    NavigationLink("Create An Account", destination: RegisterView())
                }
                .padding(.bottom, 50)

                Spacer() // Pushes the content towards the top
            }
            .navigationBarHidden(true) // Hide navigation bar for this view
        }
    }
}

#Preview {
    LoginView()
}
