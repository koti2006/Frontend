import SwiftUI

struct WelcomeView: View {
    
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("Get Start")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(
                        // dark overlay to match screenshot
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.55), Color.black.opacity(0.55)]),
                            startPoint: .top,
                            endPoint: .bottom)
                    )

                VStack {
                    Spacer().frame(height: 70) // top spacing for notch area

                    // Circular logo
                    Image("Renty_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .background(Color.black.opacity(0.35))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.06), lineWidth: 0.5))
                        .shadow(color: Color.black.opacity(0.6), radius: 8, x: 0, y: 4)

                    Spacer().frame(height: 40)

                    // Title - multiline and centered
                    Text("Welcome to Renty")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)

                    Spacer().frame(height: 360)

                    // Description paragraph
                    Text("Discover your next adventure with renty. we're here to provide you with a seamless Product rental experience. Let's get started on your journey.")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 36)

                    Spacer()

                    // Get Started button
                    Button(action: {
                        // trigger navigation
                        navigateToLogin = true
                    }) {
                        Text("Get Started")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                    }
                    .background(
                        Capsule()
                            .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    )
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 60)
                    .shadow(color: Color.black.opacity(0.45), radius: 10, x: 0, y: 6)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Invisible NavigationLink for programmatic navigation
                NavigationLink(
                    destination: LoginView()
                        .navigationBarHidden(true),
                    isActive: $navigateToLogin
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarHidden(true)

        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview inside a NavigationStack so the NavigationLink works in preview
            NavigationStack {
                WelcomeView()
            }
            .previewDevice("iPhone 14 Pro")
            .preferredColorScheme(.dark)
        }
    }
}
