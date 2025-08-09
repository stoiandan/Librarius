import Foundation
import SwiftUI


struct Tag : Identifiable, Hashable, Sendable {
    
    let id = UUID()
    let description: String
    let color: Color
}


extension Tag {
    static var examples: [Tag] {
        [
            .init(description: "Sci-Fi", color: .blue),
            .init(description: "Roamnce", color: .black),
            .init(description: "Religion", color: .white),
            .init(description: "Technical", color: .brown),
            .init(description: "Cooking", color: .green),
            .init(description: "Sports", color: .indigo),
            .init(description: "Teas", color: .mint),
        ]
    }
}
