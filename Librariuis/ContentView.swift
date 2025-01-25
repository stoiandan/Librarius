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
            
            for url in urls {
                Task.detached {
                    await withTaskGroup(of: CGImage.self, returning: [CGImage].self) {  group in
                        var thumbnails: [CGImage] = []
                        
                        group.addTask {
                            let thumbnail = await createThunmbnail(for: url, of: CGSize(width: 254, height: 254), scale: displayScale)
                            thumbnails.append(thumbnail)
                        }
                        
                        await group.waitForAll()
                        
                        return thumbnails
                        
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
