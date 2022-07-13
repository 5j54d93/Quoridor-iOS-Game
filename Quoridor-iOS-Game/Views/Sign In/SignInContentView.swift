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
    @State private var showProgressView = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    
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
                        SignInWithEmailView(authViewModel: authViewModel, playerViewModel: playerViewModel, playerType: $playerType, isSignInWithEmail: $isSignInWithEmail, showProgressView: $showProgressView, alertMessage: $alertMessage, showAlert: $showAlert, geometry: geometry)
                    } else {
                        ChooseSignInMethodView(authViewModel: authViewModel, playerViewModel: playerViewModel, playerType: $playerType, isSignInWithEmail: $isSignInWithEmail, showProgressView: $showProgressView, alertMessage: $alertMessage, showAlert: $showAlert, geometry: geometry)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .overlay {
                if showProgressView {
                    Color.white
                        .ignoresSafeArea()
                        .opacity(0.7)
                    
                    if !showAlert {
                        ProgressView()
                            .scaleEffect(3)
                            .progressViewStyle(CircularProgressViewStyle(tint: .roseGold))
                    } else {
                        VStack(spacing: 20) {
                            Text(alertMessage)
                                .foregroundColor(.roseGold)
                            
                            Button {
                                showProgressView = false
                                showAlert = false
                            } label: {
                                Text("OK")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        Capsule()
                                            .foregroundColor(.roseGold)
                                    }
                            }
                        }
                        .padding(20)
                        .frame(width: geometry.size.width*0.8)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
}
