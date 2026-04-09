import SwiftUI

struct SplashScreen: View {
    @State private var circleVisible = false
    @State private var logoVisible = false
    @State private var goToWelcome = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // Pop container: circle + logo
                ZStack {
                    // Circle background that pops in
                    Circle()
                        .fill(Color.black)
                        .frame(width: 220, height: 220)
                        .scaleEffect(circleVisible ? 1.0 : 0.6)
                        .opacity(circleVisible ? 1.0 : 0.0)
                        .shadow(color: Color.black.opacity(circleVisible ? 0.35 : 0.0),
                                radius: circleVisible ? 18 : 0, x: 0, y: 12)
                        .animation(.easeOut(duration: 0.35), value: circleVisible)

                    // Logo that does the pop + bounce
                    Image("Renty_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 120)
                        .scaleEffect(logoVisible ? 1.0 : 0.28)
                        .rotationEffect(.degrees(logoVisible ? 0 : -10))
                        .opacity(logoVisible ? 1.0 : 0.0)
                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 8)
                        .animation(
                            .interpolatingSpring(stiffness: 160, damping: 12)
                                .speed(1.05)
                                .delay(0.08),
                            value: logoVisible
                        )
                }
            }
            .onAppear {
                // orchestrate a quick circle first, then logo pop
                withAnimation(.easeOut(duration: 0.28)) { circleVisible = true }

                // small delay so the circle appears before the logo pops
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    logoVisible = true
                }

                // Auto navigation after 3 seconds (unchanged)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    goToWelcome = true
                }
            }
            .navigationDestination(isPresented: $goToWelcome) {
                WelcomeView()
            }
        }
    }
}

#Preview {
    SplashScreen()
}
