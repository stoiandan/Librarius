import Foundation
import SwiftUI

struct Tag : Identifiable, Hashable {
    let id = UUID()
    let description: String
    let color: Color
}

extension Tag: Comparable {
    static func < (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id < rhs.id
    }
}



func getBook(from books: [Book], with id: String) -> Book? {
    books.first { $0.id.uuidString == id }
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
    
    static var shortExamples: [Tag] {
        [
            .init(description: "Sci-Fi", color: .blue),
            .init(description: "Roamnce", color: .black),
        ]
    }
}
