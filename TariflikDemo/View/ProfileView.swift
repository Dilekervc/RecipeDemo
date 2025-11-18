import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView("Yükleniyor...")
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text(name)
                    .font(.title)
                    .fontWeight(.bold)

                Text(email)
                    .foregroundColor(.gray)

                Button(action: signOut) {
                    Text("Çıkış Yap")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
            }
        }
        .onAppear(perform: fetchUserData)
        .padding()
    }

    // 🔹 Firestore’dan kullanıcı bilgilerini çek
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.name = data?["name"] as? String ?? "Bilinmiyor"
                self.email = data?["email"] as? String ?? "Bilinmiyor"
            }
            self.isLoading = false
        }
    }

    // 🔹 Çıkış yapma
    func signOut() {
        do {
            try Auth.auth().signOut()
            // App yeniden başlatılırsa SignInView görünecek
        } catch {
            print("Çıkış hatası: \(error.localizedDescription)")
        }
    }
}
