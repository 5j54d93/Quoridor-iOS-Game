//
//  ChooseSignInMethodView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/6/28.
//

import SwiftUI

struct ChooseSignInMethodView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var playerType: SignInContentView.PlayerType
    @Binding var isSignInWithEmail: Bool
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                
            Button {
                appState = .loading
                authViewModel.signInWithFacebook() { result in
                    if result == "success" {
                        if let user = authViewModel.currentUser {
                            playerViewModel.isNewPlayer(email: user.providerData[0].email!) { result in
                                if case true = result {
                                    playerViewModel.addPlayer(id: user.uid, email: user.providerData[0].email, name: user.providerData[0].displayName, avatar: user.providerData[0].photoURL) { result in
                                        if case .failure(let error) = result {
                                            alertTitle = "ERROR"
                                            alertMessage = error.localizedDescription
                                            appState = .alert
                                        }
                                    }
                                }
                                appState = .null
                            }
                        }
                    } else {
                        alertTitle = "ERROR"
                        alertMessage = result
                        appState = .alert
                    }
                }
            } label: {
                HStack {
                    Image("FacebookLogo")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 6)
                        .padding(.vertical, 6)
                    
                    Text(LocalizedStringKey(playerType.description + " with Facebook"))
                        .font(.title3.bold())
                        .foregroundColor(.roseGold)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width*0.7, height: 52)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                }
            }
            
            Button {
                appState = .loading
                authViewModel.signInWithGoogle() { result in
                    switch result {
                    case .success():
                        appState = .null
                        if let user = authViewModel.currentUser {
                            playerViewModel.isNewPlayer(email: user.providerData[0].email!) { result in
                                if case true = result {
                                    playerViewModel.addPlayer(id: user.uid, email: user.providerData[0].email, name: user.providerData[0].displayName, avatar: user.providerData[0].photoURL) { result in
                                        if case .failure(let error) = result {
                                            alertTitle = "ERROR"
                                            alertMessage = error.localizedDescription
                                            appState = .alert
                                        }
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        alertTitle = "ERROR"
                        alertMessage = error.localizedDescription
                        appState = .alert
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: geometry.size.width*0.7, height: 52)
                    .foregroundColor(.white)
                    .overlay {
                        HStack {
                            Image("GoogleLogo")
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, 6)
                                .padding(.vertical, 6)
                            
                            Text(LocalizedStringKey(playerType.description + " with Google"))
                                .font(.title3.bold())
                                .foregroundColor(.roseGold)
                            
                            Spacer()
                        }
                    }
            }
            
            Button {
                appState = .loading
                authViewModel.signInWithTwitter() { result in
                    switch result {
                    case .success():
                        appState = .null
                        if let user = authViewModel.currentUser {
                            playerViewModel.isNewPlayer(email: user.providerData[0].email!) { result in
                                if case true = result {
                                    playerViewModel.addPlayer(id: user.uid, email: user.providerData[0].email, name: user.providerData[0].displayName, avatar: user.providerData[0].photoURL) { result in
                                        if case .failure(let error) = result {
                                            alertTitle = "ERROR"
                                            alertMessage = error.localizedDescription
                                            appState = .alert
                                        }
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        alertTitle = "ERROR"
                        alertMessage = error.localizedDescription
                        appState = .alert
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: geometry.size.width*0.7, height: 52)
                    .foregroundColor(.white)
                    .overlay {
                        HStack {
                            Image("TwitterLogo")
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, 6)
                                .padding(.vertical, 6)
                            
                            Text(LocalizedStringKey(playerType.description + " with Twitter"))
                                .font(.title3.bold())
                                .foregroundColor(.roseGold)
                            
                            Spacer()
                        }
                    }
            }
            
            Button {
                withAnimation {
                    isSignInWithEmail = true
                }
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: geometry.size.width*0.7, height: 52)
                    .foregroundColor(.roseGold)
                    .overlay {
                        Text(LocalizedStringKey(playerType.description + " with Email"))
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    }
            }
            
            Spacer()
            
            HStack {
                Button {
                    playerType = .null
                } label: {
                    Text(Image(systemName: "arrow.backward.circle"))
                        .font(.largeTitle)
                        .foregroundColor(.lightBrown)
                }
                .padding(.leading)
                .padding(.bottom)
                
                Spacer()
            }
        }
    }
}
