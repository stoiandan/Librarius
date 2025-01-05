import SwiftUI
import SwiftData
import QuickLookThumbnailing

struct ContentView: View {
    @State var tags: [Tag] = []
        
    @State var pdfs: [(NSImage, URL)] = []
    
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
            if pdfs.isEmpty {
                Text("Drop your PDFs here")
                    .font(.title)
                Image(systemName: "document.badge.plus")
                    .resizable()
                    .frame(width: 64, height: 64)
            } else {
                List(pdfs, id: \.1) { pdf in
                    VStack {
                        Image(nsImage: pdf.0)
                        Text(pdf.1.lastPathComponent)
                    }
                    .padding()
                }
            }
        })
        .dropDestination(for: URL.self) { paths, _ in
           
            for path in paths {
                createThunmbnail(for: path, of: CGSize(width: 128, height: 128))
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
    
    func createThunmbnail(for url: URL, of size: CGSize)  {
        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: 1.0 as CGFloat, representationTypes: .thumbnail)
        
        QLThumbnailGenerator.shared.generateRepresentations(for: request) {
            representation, type, err in
            
            guard err == nil else {
                fatalError("Cannot generate thumbnail")
            }
            
            if let representation {
                pdfs.append((representation.nsImage, url))
            }
        }
    }
}


#Preview {
    ContentView(tags: Tag.examples)
    
}
