import SwiftUI

struct RootView: View {
 
    @AppStorage("LoginView") private var isLoggedIn: Bool = false

    var body: some View {
        Group {
            if isLoggedIn == false {
                SplashScreen()
            } else {
                NavigationStack {
                    MainTabView()
                }
               
            }
        }
    }
}

#Preview{
    RootView()
}

