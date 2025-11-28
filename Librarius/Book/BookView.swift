import SwiftUI

struct BookView: View {
    @Environment(\.displayScale) var displayScale
    
    let book: Book
    
    var body: some View {
        VStack {
            Image(nsImage: book.image)
                .resizable()
                .scaledToFit()
            Text(book.title)
                .lineLimit(3)
                .font(.headline)
            HStack {
                ForEach(book.tags.sorted(), id: \.self) { tag in
                    TagView(tag: tag)
                }
            }
        }
    }
}
