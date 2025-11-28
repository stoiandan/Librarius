import Foundation
import SwiftUI
import CoreGraphics
import SwiftData


@Model
final class Book: Identifiable  {
    
    @Relationship(deleteRule: .cascade)
    var tags: [Tag] = []
    
    
    var url: URL
    
    var imageData: Data
    
    var image: NSImage {
        NSImage(data: imageData)!
    }
    
    init(url: URL, imageData: Data) {
        self.url = url
        self.imageData = imageData
    }
    
    init(from transferable: TransferableBook) {
        self.url = transferable.url
        self.imageData = transferable.imageData
    }
    
    func addTag(_ tag: Tag)  {
        tags.append(tag)
    }
    
    func removeTag(_ tag: Tag)  {
        tags.remove(at: tags.firstIndex(of: tag)!)
    }
    
    func hasTag(_ tagID: PersistentIdentifier) -> Bool {
        tags.first { $0.persistentModelID == tagID } != nil
    }
    
    var title: String {
        if !url.pathExtension.isEmpty {
            String(url.lastPathComponent.prefix(url.lastPathComponent.count -  url.pathExtension.count - 1))
        } else {
            url.lastPathComponent
        }
    }
}



extension Book {
    struct BookTransferable: nonisolated Codable {
        let persistanceIdentifier: PersistentIdentifier
    }
}



extension Book.BookTransferable: nonisolated Transferable {
    nonisolated static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
    }
}


