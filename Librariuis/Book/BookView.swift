//
//  BookView.swift
//  Librariuis
//
//  Created by Dan Stoian on 05.01.2025.
//

import SwiftUI

struct BookView: View {
    let book: Book
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    @Previewable @Environment(\.displayScale) var displayScale
    
    let book: Book =  {
        let url = URL(string: "https://swifteducation.github.io/assets/pdfs/XcodeKeyboardShortcuts.pdf")!
        
        await Task.detached {
            let thumbnail = await createThunmbnail(for: url, of: CGSize(width: 254, height: 254), scale: displayScale)
            return Book(url: url, thumbnail: thumbnail)
        }
    }()
    
    BookView(book: book)
}
