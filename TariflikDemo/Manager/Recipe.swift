import Foundation

struct Recipe: Identifiable {
    var id: String
    var name: String
    var description: String
    var ingredients: [String]
    var instructions: String
    var imageURL: String?
    
    init(id: String = UUID().uuidString,
         name: String,
         description: String,
         ingredients: [String],
         instructions: String,
         imageURL: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageURL = imageURL
    }
    
    // Firestore'dan manuel dönüşüm
    init?(from data: [String: Any], id: String) {
        guard let name = data["name"] as? String,
              let description = data["description"] as? String,
              let ingredients = data["ingredients"] as? [String],
              let instructions = data["instructions"] as? String else {
            return nil
        }
        self.id = id
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageURL = data["imageURL"] as? String
    }
    
    // Firestore’a veri kaydetmek için
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "description": description,
            "ingredients": ingredients,
            "instructions": instructions,
            "imageURL": imageURL ?? ""
        ]
    }
}
