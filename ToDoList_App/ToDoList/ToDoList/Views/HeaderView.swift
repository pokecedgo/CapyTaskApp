import SwiftUI

struct HeaderView: View {
   // let title: String
   // let subtitle: String
    let angle: Double
    let background: Color
    let image: Image
    let icon_angle: Double
    
    var body: some View {
        ZStack {
            // Rotated background rectangle
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(background)
                .rotationEffect(Angle(degrees: angle))
                .offset(y: -40)
            
            // Content VStack
            VStack(spacing: 10) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300) // Adjust the height as needed
                    .padding()
                    .offset(x:20, y: 20)
                    .rotationEffect(Angle(degrees: icon_angle))
                
              /*  Text(title)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                
                Text(subtitle)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8)) */
            }
            .padding(.top, 30)
        }
        .frame(width: UIScreen.main.bounds.width * 1.5, height: 300)
        .offset(y: -100)
    }
}

#Preview {
    HeaderView(
        angle: 15,
        background: .brown,
        image: Image("to_do_icon"),
        icon_angle: 15)// Replace with your custom image for preview
    
}

