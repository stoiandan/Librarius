import Foundation
import SwiftUI

nonisolated struct Tag : Identifiable, Hashable {
    let id = UUID()
    let description: String
    let color: Color
}

extension Tag: Transferable {
  nonisolated static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.id.uuidString)
    }
}





func getTag(from tags: [Tag], with id: String) -> Tag? {
    tags.first { $0.id.uuidString == id }
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
