import SwiftUI
import SwiftData


struct BookGridView: View {
    let columns = [GridItem(.adaptive(minimum: 170), spacing: 10, alignment: .top)]
    
    @Query private var books: [Book]
    
    init(selectedTag: Tag? = nil) {
        guard let selectedTagID = selectedTag?.persistentModelID else {
            _books = Query()
            return
        }

        _books = Query(filter: #Predicate<Book> { book in
            book.tags.contains { $0.persistentModelID == selectedTagID }
        })
    }
        
    var body: some View {
        if books.isEmpty {
            VStack {
                Text("Drop your PDFs here")
                    .font(.title)
                Image(systemName: "document.badge.plus")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 200,height: 200)
        } else {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(books) { book in
                        BookView(book: book)
                            .draggable(Book.DragItem(persistentIdentifier: book.id))
                    }
                }
            }
        }
    }
}

#Preview(traits: .modifier(BookProvider())) {
    BookGridView()
}
