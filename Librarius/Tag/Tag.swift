import Foundation
import SwiftUI
import SwiftData

@Model
class Tag : Identifiable {
    private(set) var name: String
    private(set) var red: Double
    private(set) var green: Double
    private(set) var blue: Double
    private(set) var alpha: Double
    
    @Relationship(inverse: \Book.tags)
    var books: [Book] = []
    
    convenience init(name: String, color: Color) {
        let nsColor = NSColor(color)
        let r = nsColor.redComponent
        let g = nsColor.greenComponent
        let b = nsColor.blueComponent
        let a = nsColor.alphaComponent
        self.init(name, r, g, b, a)
    }
    
    init(_ name: String, _ red: Double, _ green: Double, _ blue: Double, _ alpha: Double) {
        self.name = name
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha

    }
    
    
    var color: Color {
        let nsColor = NSColor(red: red, green: green, blue: blue, alpha: alpha)
        return Color(nsColor)
    }
    
    
}


extension Tag: nonisolated Comparable {
    nonisolated static func < (lhs: Tag, rhs: Tag) -> Bool {
        lhs.persistentModelID < rhs.persistentModelID
    }
}

func getBook(from books: [Book], with id: PersistentIdentifier) -> Book? {
    books.first { $0.id == id }
}



extension Tag {
    
    static var examples: [Tag] {
        [
            .init(name: "Sci-Fi", color: Color.blue),
            .init(name: "Roamnce", color: Color.black),
            .init(name: "Religion", color: Color.white),
            .init(name: "Technical", color: Color.brown),
            .init(name: "Cooking", color: Color.green),
            .init(name: "Sports", color: Color.indigo),
            .init(name: "Teas", color: Color.mint),
        ]
    }
    
    static var shortExamples: [Tag] {
         [
            .init(name: "Sci-Fi", color: Color.blue),
            .init(name: "Roamnce", color: Color.black),
        ]
    }
}

