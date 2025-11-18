import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DiscoverView()
                .tabItem {
                    Label("Keşfet", systemImage: "house.fill")
                }
            
            AddRecipeView()
                .tabItem {
                    Label("Ekle", systemImage: "plus.circle.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Hesabım", systemImage: "person.crop.circle.fill")
                }
        }
        .tint(Color(red: 1.0, green: 0.525, blue: 0.376))
    }
}

#Preview {
    MainTabView()
}
