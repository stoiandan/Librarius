import SwiftUI
import SwiftData

struct ContentView: View {
    @State var tags: [Tag] = []
    
    @State var collects: [String] = []
    
    @State var isCreatingTag = false
    
    @Environment(\.displayScale) var displayScale
    
    @State var books: [Book] = []
    
    var body: some View {
        NavigationSplitView(sidebar: {
            Section("Tags") {
                List(tags) { tag in
                    TagView(tag: tag)
                        .draggable(tag)
                }
            }
            Section("Collections") {
                List(collects, id: \.self) { col in
                    Text(col)
                }
            }
        }, detail: {
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
                BookGridView(books: $books, tags: tags)
            }
        })
        .dropDestination(for: URL.self, action: handleDrop)
        .navigationTitle("Librarius")
        .toolbar {
            ToolbarItem {
                Button("add tag", systemImage: "plus") {
                    isCreatingTag.toggle()
                }
                .sheet(isPresented: $isCreatingTag) {
                    TagCreator(tags: $tags, isPresented: $isCreatingTag)
                }
            }
        }
    }
    
    
    func handleDrop(urls: [URL], point: CGPoint) -> Bool {
        Task.detached {
            await withTaskGroup {  group in
                for url in urls {
                    group.addTask {
                        let book = await createBook(for: url, of: CGSize(width: 200, height: 200), scale: 4.0)
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
    
}


struct BookProvider: PreviewModifier {
    static func makeSharedContext() async -> [Book] {
        let url = Bundle.main.url(forResource: "Curs confirmare RO", withExtension: "pdf")!
        
        return await withTaskGroup { tg in
            for _ in 0..<10 {
                tg.addTask {
                    return await createBook(for: url, of: CGSize(width: 200, height: 200), scale: 4.0)
                }
            }
            var books: [Book] = []
            for await result in tg {
                books.append(result)
            }
            return books
        }
    }
    
    
    func body(content: Content, context: [Book]) -> some View {
        ContentView(books: context)
    }
}



#Preview(traits: .modifier(BookProvider())) {
    ContentView(tags: Tag.examples)
        .frame(width: 400, height: 600)
}
