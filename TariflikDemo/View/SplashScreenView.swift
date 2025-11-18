import SwiftUI

struct SplashScreenView: View {
    @State private var animateIn = false
    @State private var animateOut = false

    var body: some View {
        ZStack {
            // Arka plan rengi
            Color(red: 1.0, green: 0.97, blue: 0.94)
                .ignoresSafeArea()
            
            // Üstteki resim
            VStack {
                HStack {
                    Image("recipebook6")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.top, 110)
                        .padding(.leading, 30)
                        .scaleEffect(animateIn ? 1.1 : 0.9)
                        .scaleEffect(animateOut ? 0.5 : 1)
                        .opacity(animateOut ? 0 : 1)
                        .animation(.easeInOut(duration: 1.2), value: animateIn)
                        .animation(.easeInOut(duration: 1.0), value: animateOut)
                    Spacer()
                }
                Spacer()
            }
            
            // Orta logo
            Image("tariflik")
                .resizable()
                .frame(width: 400, height: 400)
                .offset(x: -10, y: -30)
                .scaleEffect(animateIn ? 1.1 : 0.9)
                .scaleEffect(animateOut ? 0.6 : 1)
                .opacity(animateOut ? 0 : 1)
                .animation(.easeInOut(duration: 1.2), value: animateIn)
                .animation(.easeInOut(duration: 1.0), value: animateOut)
            
            // Alt köşe resmi
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("recipebook7")
                        .resizable()
                        .frame(width: 130, height: 130)
                        .padding(.trailing, 30)
                        .padding(.bottom, 110)
                        .scaleEffect(animateIn ? 1.1 : 0.9)
                        .scaleEffect(animateOut ? 0.5 : 1)
                        .opacity(animateOut ? 0 : 1)
                        .animation(.easeInOut(duration: 1.2), value: animateIn)
                        .animation(.easeInOut(duration: 1.0), value: animateOut)
                }
            }
        }
        .onAppear {
            // Açılışta büyüme animasyonu
            withAnimation(.easeInOut(duration: 1.2)) {
                animateIn = true
            }
            // 2 saniye sonra küçülme (kapanış) animasyonu
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animateOut = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
