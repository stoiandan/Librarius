import SwiftUI

struct BookView: View {
    let book: Book
    
    var body: some View {
        VStack {
            Image(book.thumbnail, scale: 1.0,
                  label: Text(book.title))
        }
    }
}



#Preview {
    @Previewable @State var book: Book? = nil

    let url = Bundle.main.url(forResource: "Curs confirmare RO", withExtension: "pdf")!
    
    Group {
        if let book {
            BookView(book: book)
        } else {
            ProgressView()
                .task {
                    book = await createBook(for: url, of: CGSize(width: 12, height: 255), scale: 1.0)
                }
        }
    }

}
