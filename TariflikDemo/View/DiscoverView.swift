import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = RecipeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.recipes.isEmpty {
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                            .scaleEffect(1.5)
                        Text("Tarifler yükleniyor...")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    .padding(.top, 100)
                } else {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.recipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    // 🔹 imageURL güvenli unwrap
                                    if let imageURL = recipe.imageURL,
                                       !imageURL.isEmpty,
                                       let url = URL(string: imageURL) {
                                        WebImage(url: url)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 200)
                                            .clipped()
                                            .cornerRadius(12)
                                    } else {
                                        // 🔹 Görsel yoksa yer tutucu
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 200)
                                            .cornerRadius(12)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .font(.largeTitle)
                                                    .foregroundColor(.gray)
                                            )
                                    }

                                    Text(recipe.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    // 🔹 ingredients dizisini metne dönüştür
                                    Text(recipe.ingredients.joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color(red: 1.0, green: 0.97, blue: 0.94).ignoresSafeArea())
            .navigationTitle("Keşfet")
            .onAppear {
                viewModel.fetchRecipes()
            }
        }
    }
}
