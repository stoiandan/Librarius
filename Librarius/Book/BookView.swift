import SwiftUI
import SwiftData

struct BookView: View {
    @Environment(\.displayScale) var displayScale
    
    let book: Book
    
    var body: some View {
        VStack {
            Image(nsImage: book.image)
                .resizable()
                .frame(width: 150, height: 200)
                .scaledToFill()
            Text(book.title)
                .lineLimit(3)
                .font(.headline)
            HStack {
                ForEach(book.tags.sorted(), id: \.self) { tag in
                    TagView(tag: tag, showText: false)
                }
            }
        }
        .padding()
    }
}


#Preview(traits: .modifier(BookProvider())) {
    
    @Previewable @Query var books: [Book]
    
    BookView(book: books.first!)
}
