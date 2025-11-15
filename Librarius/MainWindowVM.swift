import Foundation
import Observation


@Observable
class MainWindowVM  {
     var tags: [Tag] = []
    
     var collections: [String] = []
    
     var isCreatingTag = false
    
    
     var books: [Book] = []
    
    
    func addTagTo(_ tag: Tag, bookId: UUID ) {
        guard let idx = books.firstIndex( where: { $0.id == bookId }) else {
            return
        }
        
        books[idx].tags.insert(tag)
    }
}
