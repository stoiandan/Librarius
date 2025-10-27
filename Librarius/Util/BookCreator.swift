

import Foundation
import QuickLookThumbnailing
import CoreGraphics

func createBook(for url: URL, of size: CGSize, scale: CGFloat, with tags: [Tag] = []) async -> Book  {
    let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .thumbnail)
    
    
    let representation = try! await QLThumbnailGenerator.shared.generateBestRepresentation(for: request)
    
    return Book(tags: tags, url: url, thumbnail: representation.cgImage, )
}
