import SwiftUI

struct BookView: View {
    @Environment(\.displayScale) var displayScale
    
    let book: Book
    
    var body: some View {
        VStack {
            Image(decorative: book.thumbnail, scale: displayScale)
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



#Preview {
    @Previewable @State var book: Book? = nil
    
    let url = Bundle.main.url(forResource: "Curs confirmare RO", withExtension: "pdf")!
    
    Group {
        if let book {
            BookView(book: book)
                .frame(width: 400, height: 500)
        } else {
            ProgressView()
                .task {
                    book = await createBook(for: url, of: CGSize(width: 120, height: 255), scale: 4.0, with: Tag.shortExamples)
                }
        }
    }
    
}
