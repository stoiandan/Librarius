import SwiftUI

private struct SelectedTagModifier: ViewModifier {
    let isSelected: Bool
    let color: Color

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background {
                if isSelected {
                    Capsule()
                        .fill(color.opacity(0.14))
                        .stroke(color.opacity(0.65), lineWidth: 1)
                        .shadow(color: color.opacity(0.45), radius: 6)
                }
            }
    }
}


extension TagView {
    func selection(isSelected: Bool, color: Color) -> some View {
        modifier(SelectedTagModifier(isSelected: isSelected, color: color))
    }
}


#Preview("Selected") {
        TagView(tag: Tag(name: "Sci-Fi", color: .blue))
            .selection(isSelected: true, color: .blue)
}

#Preview("Unselected") {
    TagView(tag: Tag(name: "Romance", color: .pink))
        .selection(isSelected: false, color: .pink)
}
