import SwiftUI

struct TagView: View {
    let tag: Tag
    
    var body: some View {
       HStack {
           tag.color
               .clipShape(.circle)
               .frame(width: 16, height: 16)
           Text(tag.description)
        }
       .padding(.horizontal)
    }
}

#Preview {
    let tag = Tag(description: "Sci-Fi", color: .blue)
    TagView(tag: tag)
}
