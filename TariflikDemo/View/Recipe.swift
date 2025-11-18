import Foundation

struct Recipe: Identifiable {
    var id: String
    var name: String
    var description: String
    var ingredients: [String]
    var instructions: String
    var imageURL: String?
}
