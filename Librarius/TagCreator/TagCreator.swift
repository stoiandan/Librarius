

import SwiftUI

struct TagCreator: View {
    @Binding var tags: [Tag]
    @Binding var isPresented: Bool
    @State var color: CGColor = .white
    @State var name = ""
    var body: some View {
        Form {
            Section() {
                TextField("Tag Name", text: $name, prompt: Text("Enter a tag name"))
            }
            
            Section() {
                ColorPicker("Pick tag color", selection: $color)

            }

            
            Button("Create Tag",) {
                tags.append(Tag(description: name, color: Color(color)))
                isPresented = false
            }
            .disabled(name == "" || tags.contains { $0.description == name })
        }
        .padding(20)
        .frame(maxWidth: 250)
    }
}

#Preview {
    TagCreator(tags: .constant([]), isPresented: .constant(true))
}
