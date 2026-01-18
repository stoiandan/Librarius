import SwiftUI
import SwiftData


struct BookGridView: View {
    let columns = [GridItem(.adaptive(minimum: 170), spacing: 10)]
    
    @Query()  var books: [Book]
    
    @Query()  var tags: [Tag]
        
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(books) { book in
                    BookView(book: book)
                        .draggable(Book.BookTransferable(persistanceIdentifier: book.id))
                }
            }
        }
    }
}

#Preview(traits: .modifier(BookProvider())) {
    BookGridView()
}
