import Foundation
import SwiftUI

struct Tag : Identifiable, Hashable, Codable {
    let id: UUID
    let description: String
    let color: Color.Resolved
    
    init(description: String, color: Color.Resolved, id: UUID = UUID()) {
        self.description = description
        self.color = color
        self.id = id
    }
    
    
}

extension Tag: Comparable {
    static func < (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id < rhs.id
    }
}



func getBook(from books: [Book], with id: String) -> Book? {
    books.first { $0.id.uuidString == id }
}



fileprivate let env = EnvironmentValues.init()


extension Tag {

    static var examples: [Tag] {
         [
            .init(description: "Sci-Fi", color: Color.blue.resolve(in: env)),
            .init(description: "Roamnce", color: Color.black.resolve(in: env)),
            .init(description: "Religion", color: Color.white.resolve(in: env)),
            .init(description: "Technical", color: Color.brown.resolve(in: env)),
            .init(description: "Cooking", color: Color.green.resolve(in: env)),
            .init(description: "Sports", color: Color.indigo.resolve(in: env)),
            .init(description: "Teas", color: Color.mint.resolve(in: env)),
        ]
    }
    
    static var shortExamples: [Tag] {
        [
            .init(description: "Sci-Fi", color: Color.blue.resolve(in: env)),
            .init(description: "Roamnce", color: Color.black.resolve(in: env)),
        ]
    }
}
