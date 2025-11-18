import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

struct AddRecipeView: View {
    @State private var recipeName = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isUploading = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 📸 Görsel seçimi
                    Button {
                        showImagePicker = true
                    } label: {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        } else {
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 50))
                                Text("Fotoğraf Ekle")
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                        }
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $selectedImage)
                    }

                    // 🍽️ Tarif Adı
                    TextField("Tarif Adı", text: $recipeName)
                        .textFieldStyle(.roundedBorder)

                    // 🧂 Malzemeler
                    TextField("Malzemeler (örnek: 2 yumurta, 1 su bardağı un...)", text: $ingredients, axis: .vertical)
                        .textFieldStyle(.roundedBorder)

                    // 👩‍🍳 Yapılışı
                    TextField("Yapılışı", text: $instructions, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .frame(minHeight: 100, alignment: .top)

                    // 💾 Kaydet Butonu
                    Button {
                        saveRecipe()
                    } label: {
                        Text(isUploading ? "Yükleniyor..." : "Kaydet")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isUploading ? .gray : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(isUploading)
                }
                .padding()
            }
            .navigationTitle("Yeni Tarif Ekle")
        }
    }

    // 🔥 Firebase'e kaydetme
    func saveRecipe() {
        guard !recipeName.isEmpty, !ingredients.isEmpty, !instructions.isEmpty else { return }
        isUploading = true

        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()

        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
            let imageRef = storageRef.child("recipeImages/\(UUID().uuidString).jpg")
            imageRef.putData(imageData) { _, error in
                if let error = error {
                    print("Fotoğraf yüklenemedi: \(error.localizedDescription)")
                    isUploading = false
                    return
                }

                imageRef.downloadURL { url, _ in
                    guard let url = url else { return }

                    // Firestore’a kaydet
                    db.collection("recipes").addDocument(data: [
                        "name": recipeName,
                        "ingredients": ingredients,
                        "instructions": instructions,
                        "imageURL": url.absoluteString,
                        "createdAt": Timestamp(date: Date())
                    ]) { error in
                        isUploading = false
                        if let error = error {
                            print("Veri kaydedilemedi: \(error.localizedDescription)")
                        } else {
                            dismiss()
                        }
                    }
                }
            }
        } else {
            // Fotoğrafsız tarif kaydı
            db.collection("recipes").addDocument(data: [
                "name": recipeName,
                "ingredients": ingredients,
                "instructions": instructions,
                "createdAt": Timestamp(date: Date())
            ]) { error in
                isUploading = false
                if let error = error {
                    print("Veri kaydedilemedi: \(error.localizedDescription)")
                } else {
                    dismiss()
                }
            }
        }
    }
}
