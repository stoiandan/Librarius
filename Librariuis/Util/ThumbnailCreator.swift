

import Foundation
import QuickLookThumbnailing
import CoreGraphics

func createThunmbnail(for url: URL, of size: CGSize, scale: CGFloat) async -> CGImage  {
    let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .thumbnail)
    
    
    let representation = try? await QLThumbnailGenerator.shared.generateBestRepresentation(for: request)
    
    guard let representation else {
        fatalError("Couldn't generate thumbnail")
    }
    
    return representation.cgImage
}
