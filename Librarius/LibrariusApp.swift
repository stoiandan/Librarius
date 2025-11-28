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
    let modelContainer = try! ModelContainer(for: Book.self, Tag.self)
    
    var body: some Scene {
        WindowGroup {
            MainWindow()
        }
        .modelContext(modelContainer.mainContext)
    }
}
