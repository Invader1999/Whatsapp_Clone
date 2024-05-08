//
//  Whatsapp_CloneApp.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 22/04/24.
//

import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Whatsapp_CloneApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
           //LoginScreen()
//            MainTabView()
            RootSrceen()
        }
    }
}
