import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    
    // Customizable size properties for the register button
    @State private var buttonWidth: CGFloat = 300 // Default width
    @State private var buttonHeight: CGFloat = 50 // Default height

    var body: some View {
        VStack {
            // Header
            HeaderView(angle: -15,
                       background: .brown,
                       image: Image("Capybara_Sleep"),
                       icon_angle: -2)
            
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

            // Register Form
            VStack(spacing: 20) {
                TextField("Full Name", text: $viewModel.name)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())

                // Customizable Create Account Button
                TLButton(
                    title: "Create Account",
                    background: .green
                ) {
                    viewModel.register()
                    // Attempt Registration
                    print("register action")
                }
                .frame(width: buttonWidth, height: buttonHeight) // Apply customizable size
                .padding(.bottom, 20)
            }
            .padding()

            Spacer()
        }
    }
}

#Preview {
    RegisterView()
}
