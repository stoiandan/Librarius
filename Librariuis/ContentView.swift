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
                }            }
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
                BookGridView(books: books)
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


#Preview {
    @Previewable @State var books: [Book]  = []
    
    let url = Bundle.main.url(forResource: "Curs confirmare RO", withExtension: "pdf")!
    
    if books.count < 5 {
        ProgressView()
            .task {
                await withTaskGroup { tg in
                    for _ in 0..<10 {
                        tg.addTask {
                            return await createBook(for: url, of: CGSize(width: 200, height: 200), scale: 4.0)
                        }
                    }
                    
                    for await result in tg {
                        await MainActor.run {
                            books.append(result)
                        }
                    }
                }
                
                
            }
    } else {
        ContentView(tags: Tag.examples, collects: ["Religion", "Sci-Fi", "Fantasy"], books: books)
            .frame(width: 700, height: 600)
        
    }
}


#Preview {
    ContentView()
}
