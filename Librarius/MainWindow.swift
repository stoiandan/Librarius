import SwiftUI
import SwiftData

struct MainWindow: View {
    @State var vm = MainWindowVM()
    
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        NavigationSplitView(sidebar: {
            Section("Tags") {
                List(vm.tags) { tag in
                    TagView(tag: tag)
                        .dropDestination(for: String.self) {
                            bookIds, session in
                            
                            bookIds.forEach { bookId in
                                vm.addTagTo(tag, bookId:   UUID(uuidString: bookId)!)
                            }
                        }
                }
            }
            Section("Collections") {
                List(vm.collections, id: \.self) { col in
                    Text(col)
                }
            }
        }, detail: {
            if vm.books.isEmpty {
                VStack {
                    Text("Drop your PDFs here")
                        .font(.title)
                    Image(systemName: "document.badge.plus")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 200,height: 200)
            } else {
                BookGridView(books: $vm.books, tags: vm.tags)
            }
        })
        .dropDestination(for: URL.self, action: handleDrop)
        .navigationTitle("Librarius")
        .toolbar {
            ToolbarItem {
                Button("add tag", systemImage: "plus") {
                    vm.isCreatingTag.toggle()
                }
                .sheet(isPresented: $vm.isCreatingTag) {
                    TagCreator(tags: $vm.tags, isPresented: $vm.isCreatingTag)
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
                        vm.books.append(book)
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
        let mw = MainWindow()
        mw.vm.books.append(contentsOf: context)
        
        return mw
    }
}



#Preview(traits: .modifier(BookProvider())) {
    let mw = MainWindow()
    mw.vm.tags.append(contentsOf: Tag.examples)
    
    return  mw.frame(width: 400, height: 600)
}
