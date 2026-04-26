import Foundation
import SwiftUI
import CoreGraphics
import SwiftData

@Model
final class Book {
    var tags: [Tag] = []

    var url: URL
    var imageData: Data

    var image: NSImage? {
        NSImage(data: imageData)
    }

    init(url: URL, imageData: Data) {
        self.url = url
        self.imageData = imageData
    }

    func addTag(_ tag: Tag)  {
        guard !tags.contains(tag) else {
            return
        }
        tags.append(tag)
    }

    var title: String {
        url.deletingPathExtension().lastPathComponent
    }
}

extension Book {
    struct DragItem: nonisolated Codable {
        let persistentIdentifier: PersistentIdentifier
    }
}

extension Book.DragItem: nonisolated Transferable {
    nonisolated static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
    }
}
