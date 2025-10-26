import SwiftUI


struct BookGridView: View {
    let columns = [GridItem(.adaptive(minimum: 170), spacing: 10)]
    @Binding var books: [Book]
    let tags: [Tag]
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach($books) { $book in
                    VStack {
                        Image(decorative: book.thumbnail, scale: displayScale)
                            .resizable()
                            .scaledToFit()
                        Text(book.title)
                            .lineLimit(3)
                    }
                    .dropDestination(for: String.self) {
                        transerables, session in
                    
                        transerables.forEach { id in
                            if let tag = getTag(from: tags, with: id) {
                                book.metadata.addTag(tag.id)
                            }
                        }
                    }
                    .border(.blue)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var books: [Book]  = []
    
    let url = Bundle.main.url(forResource: "Curs confirmare RO", withExtension: "pdf")!
}
