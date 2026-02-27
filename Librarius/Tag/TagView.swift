import SwiftUI

struct TagView: View {
    let tag: Tag
    
    var showText = true
    
    var body: some View {
        HStack {
            Color(tag.color)
                .clipShape(.circle)
                .frame(width: 16, height: 16)
            if showText {
                Text(tag.name)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    @Previewable @Environment(\.self) var env
    let tag = Tag(name: "Sci-Fi", color: Color.blue)
    TagView(tag: tag)
}
