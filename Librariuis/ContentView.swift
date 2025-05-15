import SwiftUI
import SwiftData

struct ContentView: View {
    @State var tags: [Tag] = []
    
    @Environment(\.displayScale) var displayScale
    
    @State var books: [Book] = []
    
    var body: some View {
        NavigationSplitView(sidebar: {
            Section("Tags") {
                List(tags) { tag in
                    TagView(tag: tag)
                }
            }
            Section("Collections") {
                
            }
        }, detail: {
            if books.isEmpty {
                Text("Drop your PDFs here")
                    .font(.title)
                Image(systemName: "document.badge.plus")
                    .resizable()
                    .frame(width: 64, height: 64)
            } else {
                List(books, id: \.self) { book in
                    VStack {
                        Image(decorative: book.thumbnail, scale: displayScale)
                        Text(book.title)
                            .lineLimit(3)
                            .frame(width: 254)
                    }
                    .padding()
                }
            }
        })
        .dropDestination(for: URL.self) { urls, _ in
            
            Task.detached {
                await withTaskGroup(of: Book.self) {  group in
                    for url in urls {
                        group.addTask {
                            let book = await createBook(for: url, of: CGSize(width: 254, height: 254), scale: displayScale)
                            return book
                        }
                    }
                    
                    
                    for await book in group {
                        await MainActor.run {
                            books.append(book)
                        }
                    }
                }
            }
            
            return true
        }
        .navigationTitle("Librarius")
        .toolbar {
            ToolbarItem {
                Button("add tag", systemImage: "plus") {
                    
                }
            }
        }
    }
    
}


#Preview {
    ContentView(tags: Tag.examples)
    
}
