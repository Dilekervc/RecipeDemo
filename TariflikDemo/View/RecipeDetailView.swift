import SwiftUI
import SDWebImageSwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                // Opsiyonel imageURL kontrolü
                if let imageURL = recipe.imageURL, !imageURL.isEmpty {
                    WebImage(url: URL(string: imageURL))
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                } else {
                    Image("mercimekcorbasi") // varsa yerel yedek görsel
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                }
                
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                
                Text("Malzemeler")
                    .font(.headline)
                // Dizi olduğu için join ile metne çeviriyoruz
                Text(recipe.ingredients.joined(separator: ", "))
                    .font(.body)
                
                Text("Yapılış")
                    .font(.headline)
                Text(recipe.instructions)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
