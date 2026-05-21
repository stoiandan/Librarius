import Foundation
import QuickLookThumbnailing
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

func createBookImportData(for url: URL, of size: CGSize, scale: CGFloat) async throws -> BookImportData {
    let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .thumbnail)
    
    
    let representation = try await QLThumbnailGenerator.shared.generateBestRepresentation(for: request)
    
    return BookImportData(url: url, imageData: try representation.cgImage.pngData())
}

struct BookImportData: Codable {
    let url: URL
    let imageData: Data
}

private extension CGImage {
    func pngData() throws -> Data {
        let data = NSMutableData()
        guard
            let destination = CGImageDestinationCreateWithData(data, UTType.png.identifier as CFString, 1, nil)
        else {
            throw BookThumbnailError.encodingFailed
        }

        CGImageDestinationAddImage(destination, self, nil)

        guard CGImageDestinationFinalize(destination) else {
            throw BookThumbnailError.encodingFailed
        }

        return data as Data
    }
}

private enum BookThumbnailError: Error {
    case encodingFailed
}
