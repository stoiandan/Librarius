//
//  LibrariuisApp.swift
//  Librariuis
//
//  Created by Dan Stoian on 04.01.2025.
//

import SwiftUI
import SwiftData

@main
struct LibrariuisApp: App {
    let modelContainer =  {
        let modelConfiguration = ModelConfiguration(
            isStoredInMemoryOnly: true)
        
        return try! ModelContainer(for: Book.self, Tag.self, configurations: modelConfiguration)
    }()
    
    var body: some Scene {
        WindowGroup {
            MainWindow()
        }
        .modelContext(modelContainer.mainContext)
    }
}
