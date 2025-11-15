import SwiftUI

struct TagView: View {
    let tag: Tag
    
    var body: some View {
       HStack {
           Color(red: 4, green: 1, blue: 4)
               .clipShape(.circle)
               .frame(width: 16, height: 16)
           Text(tag.description)
               .padding(.horizontal)
        }
    }
}

#Preview {
    @Previewable @Environment(\.self) var env
    let tag = Tag(description: "Sci-Fi", color: Color.blue.resolve(in: env) )
    TagView(tag: tag)
}
