//
//  SignInContentView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/6.
//

import SwiftUI

struct SignInContentView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var hadTouchedScreen: Bool
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    enum PlayerType {
        case null, returning, new
        
        var description: String {
            switch self {
            case .null: return ""
            case .returning: return "Sign in"
            case .new: return "Sign up"
            }
        }
    }
    
    @State private var playerType: PlayerType = .null
    @State private var isSignInWithEmail = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 30) {
                Text("QUORIDOR")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                if playerType == .null {
                    ChoosePlayerTypeView(playerType: $playerType, geometry: geometry)
                } else {
                    if isSignInWithEmail {
                        SignInWithEmailView(authViewModel: authViewModel, playerViewModel: playerViewModel, playerType: $playerType, isSignInWithEmail: $isSignInWithEmail, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage, geometry: geometry)
                    } else {
                        ChooseSignInMethodView(authViewModel: authViewModel, playerViewModel: playerViewModel, playerType: $playerType, isSignInWithEmail: $isSignInWithEmail, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage, geometry: geometry)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .onAppear {
                hadTouchedScreen = false
            }
        }
    }
}
