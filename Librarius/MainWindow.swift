import SwiftUI
import SwiftData

struct MainWindow: View {
    @Environment(\.displayScale) var displayScale
    
    @Environment(\.modelContext) var context
    
    @State var isCreatingTag = false
    
    @Query() var books: [Book]
    
    @Query() var tags: [Tag]
    
    @State var collections: [String] = []
    
    var body: some View {
        NavigationSplitView(sidebar: {
            Section("Tags") {
                List(tags) { tag in
                    TagView(tag: tag)
                        .dropDestination(for: Book.BookTransferable.self) {
                            droppedBooks, session in
                            attach(tag: tag, to: droppedBooks.map(\.persistanceIdentifier))
                        }
                }
            }
            Section("Collections") {
                List(collections, id: \.self) { col in
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
                BookGridView()
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
                    TagCreator(tags: tags, isPresented: $isCreatingTag)
                }
            }
        }
    }
    
    
    func handleDrop(urls: [URL], point: CGPoint) -> Bool {
        Task {
            await withTaskGroup {  group in
                for url in urls {
                    group.addTask {
                        await createBook(for: url, of: CGSize(width: 200, height: 200), scale: 4.0)
                    }
                }
                
                for await transferableBook in group {
                    context.insert(Book(from: transferableBook))
                }
                try? context.save()
            }
        }
        return true
    }
    
    func attach(tag: Tag, to booksIDs: [PersistentIdentifier]){
        let descriptor = FetchDescriptor<Book>(
            predicate: #Predicate { book in
                booksIDs.contains(book.id)
            }
        )
        guard let books = try? context.fetch(descriptor) else {
            return
        }
        
        for book in books {
            book.addTag(tag)
        }
        
        try? context.save()
    }
    
}


struct BookProvider: PreviewModifier {
    static func makeSharedContext() async -> ModelContext {
        let url = Bundle.main.url(forResource: "Curs confirmare RO", withExtension: "pdf")!
        
        let container = try! ModelContainer(for: Book.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        let context = ModelContext(container)
        
        await withTaskGroup { tg in
            for _ in 0..<10 {
                tg.addTask {
                    await createBook(for: url, of: CGSize(width: 200, height: 2000), scale: 4.0)
                }
            }
            
            for await transferableBook in tg {
                context.insert(Book(from: transferableBook))
            }
        }
        
        return context
    }
    
    
    func body(content: Content, context: ModelContext) -> some View {
        content
            .modelContext(context)
    }
}



#Preview(traits: .modifier(BookProvider())) {
    MainWindow()
        .frame(width: 400, height: 600)
}
