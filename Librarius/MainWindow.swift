import SwiftUI
import SwiftData

struct MainWindow: View {
    @Environment(\.displayScale) var displayScale
    
    @Environment(\.modelContext) var context
    
    @State var isCreatingTag = false
    
    @State var selectedTag: Tag?
    
    @Query() var tags: [Tag]
    
    @State var collections: [String] = []
    
    var body: some View {
        NavigationSplitView(sidebar: {
            Section("Tags") {
                List(tags) { tag in
                    TagView(tag: tag)
                        .dropDestination(for: Book.DragItem.self) {
                            droppedBooks, session in
                            attach(tag: tag, to: droppedBooks.map(\.persistentIdentifier))
                        }
                        .onTapGesture {
                            selectedTag = tag
                        }
                }
            }
            Section("Collections") {
                List(collections, id: \.self) { col in
                    Text(col)
                }
            }
        }, detail: {
            BookGridView(selectedTag: selectedTag)
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
                        try? await createBookImportData(for: url, of: CGSize(width: 200, height: 200), scale: 4.0)
                    }
                }
                
                for await result in group {
                    if let bookImportData = result {
                        context.insert(Book(url: bookImportData.url, imageData: bookImportData.imageData))
                    }
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
        let url = Bundle.main.url(forResource: "text", withExtension: "pdf")!
        
        let container = try! ModelContainer(for: Book.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        let context = ModelContext(container)
        
        await withTaskGroup { tg in
            for _ in 0..<10 {
                tg.addTask {
                    try? await createBookImportData(for: url, of: CGSize(width: 200, height: 2000), scale: 4.0)
                }
            }
            
            for await result in tg {
                guard let bookImportData = result else {
                    continue
                }
                let book = Book(url: bookImportData.url, imageData: bookImportData.imageData)
                book.addTag(Tag.examples.first!)
                context.insert(book)
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
        .frame(width: 950, height: 600)
}
