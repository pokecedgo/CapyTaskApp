import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewViewModel()
    
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

        
                // Login Form
                Form {
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
                    
                    TLButton(
                        title: "Log In",
                        background: .brown
                    ) {
                        // Attempt login
                        viewModel.login()
                    }
                    .padding(.bottom, 20)
                }
                
                
                // Create Account
                VStack {
                    Text("New around here?")
                    
                    NavigationLink("Create An Account",
                                   destination: RegisterView())
                   
                }
                .padding(.bottom, 50)
                
                
                Spacer() // moves it up (top)
            }
        }
    }
}

#Preview {
    LoginView()
}
