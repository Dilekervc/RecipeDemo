import Foundation
import FirebaseFirestore
import Combine


@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []  // 🔹 Bu satır çok önemli
    
    private var db = Firestore.firestore()
    
    func fetchRecipes() {
        db.collection("recipes").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("❌ Firestore hata: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("⚠️ Firestore: Doküman bulunamadı")
                return
            }
            
            DispatchQueue.main.async {
                self?.recipes = documents.map { document in
                    let data = document.data()
                    return Recipe(
                        id: document.documentID,
                        name: data["name"] as? String ?? "Bilinmeyen Tarif",
                        description: data["description"] as? String ?? "",
                        ingredients: data["ingredients"] as? [String] ?? [],
                        instructions: data["instructions"] as? String ?? "",
                        imageURL: data["imageURL"] as? String
                    )
                }
            }
        }
    }
}
