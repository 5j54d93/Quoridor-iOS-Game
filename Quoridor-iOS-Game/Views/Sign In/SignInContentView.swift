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
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var isErrorOccured = false
    
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
                        SignInWithEmailView(authViewModel: authViewModel, playerViewModel: playerViewModel, playerType: $playerType, isSignInWithEmail: $isSignInWithEmail, isLoading: $isLoading, errorMessage: $errorMessage, isErrorOccured: $isErrorOccured, geometry: geometry)
                    } else {
                        ChooseSignInMethodView(authViewModel: authViewModel, playerViewModel: playerViewModel, playerType: $playerType, isSignInWithEmail: $isSignInWithEmail, isLoading: $isLoading, errorMessage: $errorMessage, isErrorOccured: $isErrorOccured, geometry: geometry)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .overlay {
                LoadingView(isLoading: $isLoading, errorMessage: $errorMessage, isErrorOccured: $isErrorOccured, geometry: geometry)
            }
        }
    }
}
