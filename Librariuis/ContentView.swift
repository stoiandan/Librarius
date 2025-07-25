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
                }
            }
            Section("Collections") {
                List(collects, id: \.self) { col in
                    Text(col)
                }
            }
        }, detail: {
            if books.isEmpty {
                Text("Drop your PDFs here")
                    .font(.title)
                Image(systemName: "document.badge.plus")
                    .resizable()
                    .frame(width: 64, height: 64)
            } else {
                let columns = [GridItem(.adaptive(minimum: 210, maximum: 300), spacing: 20)]
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(books) { book in
                            VStack {
                                Image(decorative: book.thumbnail, scale: displayScale)
                                Text(book.title)
                                    .lineLimit(3)
                                    .frame(width: 200)
                            }
                            .border(.blue)
                        }
                    }
                }
            }
        })
        .dropDestination(for: URL.self) { urls, _ in
            
            Task.detached {
                await withTaskGroup {  group in
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
                    isCreatingTag.toggle()
                }
                .sheet(isPresented: $isCreatingTag) {
                    TagCreator(tags: $tags, isPresented: $isCreatingTag)
                }
            }
        }
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
                            return await createBook(for: url, of: CGSize(width: 120, height: 80), scale: 1.0)
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
            .frame(width: 4000, height: 2000)
        
    }
}


