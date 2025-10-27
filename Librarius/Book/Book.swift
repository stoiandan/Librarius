import Foundation
import CoreGraphics


struct Book : Equatable, Hashable, Identifiable {
    let id = UUID()
    var tags: Set<Tag> = []
    
    
    let url: URL
    
    let thumbnail: CGImage
    
    init(tags: [Tag], url: URL, thumbnail: CGImage) {
        self.tags = Set(tags)
        self.url = url
        self.thumbnail = thumbnail
    }
    
    init (url: URL, thumbnail: CGImage) {
        self.url = url
        self.thumbnail = thumbnail
    }
    
    mutating func addTag(_ tag: Tag)  {
        tags.insert(tag)
    }
    
    mutating func removeTag(_ tag: Tag)  {
        tags.remove(tag)
    }
    
    func hasTag(_ tagID: UUID) -> Bool {
        tags.first { $0.id == tagID } != nil
    }
    
    var title: String {
        if !url.pathExtension.isEmpty {
            String(url.lastPathComponent.prefix(url.lastPathComponent.count -  url.pathExtension.count - 1))
        } else {
            url.lastPathComponent
        }
    }
}
