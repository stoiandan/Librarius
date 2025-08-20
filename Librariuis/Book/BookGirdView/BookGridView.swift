import SwiftUI


struct BookGridView: View {
    let columns = [GridItem(.adaptive(minimum: 170), spacing: 10)]
    let books: [Book]
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(books) { book in
                    VStack {
                        Image(decorative: book.thumbnail, scale: displayScale)
                            .resizable()
                            .scaledToFit()
                        Text(book.title)
                            .lineLimit(3)
                    }
                    .contextMenu {
                        Button("How are you") {
                            
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
