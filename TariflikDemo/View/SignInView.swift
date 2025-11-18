import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Giriş Yap")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                TextField("E-posta", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Şifre", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button(action: signInUser) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Giriş Yap")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color(red: 1.0, green: 0.97, blue: 0.94))
        }
    }

    func signInUser() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "E-posta ve şifre gerekli."
            return
        }

        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }

            errorMessage = "✅ Giriş başarılı!"
        }
    }
}
