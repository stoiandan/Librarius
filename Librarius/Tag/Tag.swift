import Foundation
import SwiftUI
import SwiftData
import CoreGraphics


@Model
class Tag : Identifiable {
    private(set) var name: String
    private(set) var red: Double
    private(set) var green: Double
    private(set) var blue: Double
    private(set) var alpha: Double
    
    convenience init(name: String, color: Color) {
        let nsColor = NSColor(color)
        let r = Double(nsColor.redComponent)
        let g = Double(nsColor.greenComponent)
        let b = Double(nsColor.blueComponent)
        let a = Double(nsColor.alphaComponent)
        self.init(name, r, g, b, a)
    }
    
    init(_ description: String, _ red: Double, _ green: Double, _ blue: Double, _ alpha: Double) {
        self.name = description
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha

    }
    
    
    var color: Color {
        let nsColor = NSColor(red: CGFloat(self.red), green: CGFloat(self.green), blue: CGFloat(self.blue), alpha: CGFloat(self.alpha))
        return Color(nsColor)
    }
    
    
}


extension Tag: nonisolated Comparable {
    nonisolated static func < (lhs: Tag, rhs: Tag) -> Bool {
        lhs.persistentModelID < rhs.persistentModelID
    }
}




func getBook(from books: [Book], with id: String) -> Book? {
    books.first { $0.id.uuidString == id }
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

