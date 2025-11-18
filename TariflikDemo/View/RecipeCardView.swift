import SwiftUI
import SDWebImageSwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    @State private var isLiked = false // ❤️ Kalp durumu

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Arka plan kartı
            HStack(spacing: 15) {
                // Görsel bölümü
                if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                    WebImage(url: url)
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 90, height: 90)
                        .cornerRadius(15)
                        .overlay(Text("📷").font(.largeTitle))
                }

                // Metin kısmı
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(recipe.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.1)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)

            // ❤️ Kalp butonu
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isLiked.toggle()
                }
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 22))
                    .foregroundColor(isLiked ? .red : .gray)
                    .padding(10)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
            .padding(8)
        }
        .padding(.horizontal)
    }
}
