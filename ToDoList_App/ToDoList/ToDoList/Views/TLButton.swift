//
//  TLButton.swift
//  ToDoList
//
//  Created by Cedric Petilos on 12/26/24.
//

import SwiftUI

struct TLButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            // Action
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(background)
                
                Text(title)
                    .foregroundStyle(Color.white)
                    .bold()
            }
        }
    }
}

#Preview {
    TLButton(title: "Value",
             background: Color.pink,
             action: {
                 print("Button tapped!")
             }) // Action closure added
}
