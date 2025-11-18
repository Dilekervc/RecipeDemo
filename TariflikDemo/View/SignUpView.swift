import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 25) {
            Text("Hesap Oluştur")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 60)

            VStack(alignment: .leading, spacing: 12) {
                TextField("Ad Soyad", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("E-posta", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Şifre", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Şifre Tekrar", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 30)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }

            if isLoading {
                ProgressView()
            } else {
                Button(action: registerUser) {
                    Text("Kayıt Ol")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
            }

            Spacer()

            Button("Zaten hesabın var mı? Giriş yap") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.gray)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Firebase Kullanıcı Kaydı
    func registerUser() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Lütfen tüm alanları doldur."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Şifreler eşleşmiyor."
            return
        }

        isLoading = true
        errorMessage = ""

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                return
            }

            guard let user = result?.user else {
                self.errorMessage = "Kullanıcı oluşturulamadı."
                self.isLoading = false
                return
            }

            // Firestore'a kullanıcı verilerini kaydet
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "uid": user.uid,
                "name": self.name,
                "email": self.email,
                "createdAt": Timestamp()
            ]) { error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Firestore hatası: \(error.localizedDescription)"
                } else {
                    // Başarılı -> Giriş ekranına dön
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
