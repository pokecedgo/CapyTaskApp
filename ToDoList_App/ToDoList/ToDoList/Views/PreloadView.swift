//
//  PreloadView.swift
//  ToDoList
//
//  Created by Cedric Petilos on 12/28/24.
//

import SwiftUI

struct PreloadView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
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
                
                ProgressView("Loading Data...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding()
                
                Text("Please wait while we load your tasks.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
        .opacity(isLoading ? 1 : 0)  // Show only when loading
        .animation(.easeInOut, value: isLoading)
    }
}

struct PreloadView_Previews: PreviewProvider {
    static var previews: some View {
        PreloadView(isLoading: .constant(true))
    }
}

