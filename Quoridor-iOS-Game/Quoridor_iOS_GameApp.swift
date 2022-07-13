//
//  Quoridor_iOS_GameApp.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/6/28.
//

import SwiftUI
import Firebase
import FacebookCore
import GoogleSignIn

@main
struct Quoridor_iOS_GameApp: App {
    
    init() {
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(UIApplication.shared)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in // Facebook sign in
                    ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
                }
                .onOpenURL { url in // Google sign in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
