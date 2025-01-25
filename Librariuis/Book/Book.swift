import Foundation
import CoreGraphics


struct Book : Equatable, Hashable {
    var metadata: Metadata = Metadata()
    
    let url: URL
    
    let thumbnail: CGImage
    
    var title: String {
        if !url.pathExtension.isEmpty {
            String(url.lastPathComponent.prefix(url.lastPathComponent.count -  url.pathExtension.count - 1))
        } else {
            url.lastPathComponent
        }
    }
    
    
    struct Metadata : Equatable, Hashable {
        fileprivate var tagIDs: Set<UUID> = []
        
        mutating func addTag(_ tagID: UUID)  {
            tagIDs.insert(tagID)
        }
        
        mutating func removeTag(_ tagID: UUID)  {
            tagIDs.remove(tagID)
        }
        
        func hasTag(_ tagID: UUID) -> Bool {
            tagIDs.contains(tagID)
        }
    }
}
