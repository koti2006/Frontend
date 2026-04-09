//
//  AppDelegate.swift
//  Renty
//
//  Created by SAIL L1 on 23/12/25.
//

import UIKit
import CometChatSDK
import CometChatUIKitSwift

class AppDelegate: NSObject, UIApplicationDelegate {

    let uikitSettings = UIKitSettings()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        uikitSettings
            .set(appID: "1673339e5f551cba2")
            .set(authKey: "b682ef81db57e90e50487c9b1d5343a1994f47a0")
            .set(region: "in")
            .subscribePresenceForAllUsers()
            .build()

        CometChatUIKit.init(uiKitSettings: uikitSettings) { result in
            switch result {
            case .success(let success):
                print("✅ CometChat UIKit Initialized:", success)
            case .failure(let error):
                print("❌ CometChat UIKit Init Failed:", error.localizedDescription)
            }
        }

        return true
    }
}
