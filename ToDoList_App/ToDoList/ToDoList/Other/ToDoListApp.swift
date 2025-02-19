//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Cedric Petilos on 12/25/24.
//
import FirebaseCore
import SwiftUI

@main
struct ToDoListApp: App {
    init() {
       FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            MainView()
            
        }
    }
}



