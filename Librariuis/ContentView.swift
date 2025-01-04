import SwiftUI
import SwiftData
import PDFKit
import QuickLook

struct ContentView: View {
    @State var tags: [Tag] = []
    
    @State var paths: [URL] = []
        
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
            if paths.isEmpty {
                Text("Drop your PDFs here")
                    .font(.title)
                Image(systemName: "document.badge.plus")
                    .resizable()
                    .frame(width: 64, height: 64)
            } else {
                List(paths, id: \.self) { path in
                    VStack {
                        Image(systemName: "document")
                        Text(path.absoluteString)
                    }
                    .padding()
                }
            }
        })
        .dropDestination(for: URL.self) { paths, _ in
            for path in paths {
                self.paths.append(path)
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
