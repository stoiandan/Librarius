import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var tags: [Tag] = []
    
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
            Text("Select a tag or collection")
                .font(.title3)
        })
        
        .navigationTitle("Librarius")
    }
}


#Preview {
    ContentView(tags: Tag.examples)
      
}
