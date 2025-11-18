import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 🔎 KEŞFET SAYFASI (Firebase'den tarifleri gösterir)
            DiscoverView()
                .tabItem {
                    Label("Keşfet", systemImage: "magnifyingglass")
                }

            // ➕ TARİF EKLE SAYFASI (Firebase'e tarif ekler)
            AddRecipeView()
                .tabItem {
                    Label("Tarif Ekle", systemImage: "plus.circle")
                }

            // 👤 PROFİL SAYFASI (kullanıcı girişi bilgileri)
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
        }
        .tint(.orange) // 👈 Sekme ikonlarının rengi
    }
}
