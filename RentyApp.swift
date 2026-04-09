

import SwiftUI


@main
struct RentyApp: App {

//    init() {
//        initializeCometChat()
//    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)
      var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }

//    private func initializeCometChat() {
//        let appID = "1673339e5f551cba2"
//        let region = "in"
//
//        let settings = AppSettings.AppSettingsBuilder()
//            .subscribePresenceForAllUsers()
//            .setRegion(region)
//            .build()
//
//        CometChatUIKit.init(appId: appID, appSettings: settings) { success in
//            if success {
//                print("✅ CometChat initialized")
//            } else {
//                print("❌ CometChat init failed")
//            }
//        }
//    }
}

