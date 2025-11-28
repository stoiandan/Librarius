

import Foundation
import QuickLookThumbnailing
import CoreGraphics
import SwiftData

func createBook(for url: URL, of size: CGSize, scale: CGFloat, with tags: [Tag] = []) async -> TransferableBook   {
    let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .thumbnail)
    
    
    let representation = try! await QLThumbnailGenerator.shared.generateBestRepresentation(for: request)
    
    return TransferableBook(url: url, imageData: representation.nsImage.tiffRepresentation!)
}


struct TransferableBook: Codable {
    let url: URL
    let imageData: Data
}
