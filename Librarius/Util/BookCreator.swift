

import Foundation
import QuickLookThumbnailing
import CoreGraphics

func createBookImportData(for url: URL, of size: CGSize, scale: CGFloat) async -> BookImportData {
    let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .thumbnail)
    
    
    let representation = try! await QLThumbnailGenerator.shared.generateBestRepresentation(for: request)
    
    return BookImportData(url: url, imageData: representation.nsImage.tiffRepresentation!)
}


struct BookImportData: Codable {
    let url: URL
    let imageData: Data
}
