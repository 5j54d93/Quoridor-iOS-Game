//
//  SettingView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/4.
//

import SwiftUI

struct SettingView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    @ObservedObject var gameViewModel: GameViewModel
    
    @Binding var isShowSettings: Bool
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                isShowSettings = false
                            }
                        } label: {
                            Text(Image(systemName: "chevron.backward"))
                                .font(.title3.bold())
                        }
                        
                        Spacer()
                    }
                    .overlay {
                        Text("Settings")
                            .font(.title2.bold())
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(Color.earthyGold)
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            Group {
                                if authViewModel.providers.contains("password") {
                                    NavigationLink {
                                        SecurityView(authViewModel: authViewModel)
                                    } label: {
                                        HStack(spacing: 10) {
                                            Image(systemName: "lock.shield")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 28, height: 28)
                                            
                                            Text("Security")
                                                .font(.title2)
                                            
                                            Spacer()
                                            
                                            Text(Image(systemName: "chevron.forward"))
                                                .foregroundColor(.earthyGold)
                                        }
                                    }
                                }
                                
                                NavigationLink {
                                    AccountView(authViewModel: authViewModel, playerViewModel: playerViewModel, isShowSettings: $isShowSettings, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage)
                                } label: {
                                    HStack(spacing: 10) {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 28, height: 28)
                                        
                                        Text("Account")
                                            .font(.title2)
                                        
                                        Spacer()
                                        
                                        Text(Image(systemName: "chevron.forward"))
                                            .foregroundColor(.earthyGold)
                                    }
                                }
                                
                                NavigationLink {
                                    GameSettingsView(gameViewModel: gameViewModel)
                                } label: {
                                    HStack(spacing: 10) {
                                        Image(systemName: "gamecontroller.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 28, height: 28)
                                        
                                        Text("Game")
                                            .font(.title2)
                                        
                                        Spacer()
                                        
                                        Text(Image(systemName: "chevron.forward"))
                                            .foregroundColor(.earthyGold)
                                    }
                                }
                                
                                NavigationLink {
                                    AboutView()
                                } label: {
                                    HStack(spacing: 10) {
                                        Image(systemName: "info.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 28, height: 28)
                                        
                                        Text("About")
                                            .font(.title2)
                                        
                                        Spacer()
                                        
                                        Text(Image(systemName: "chevron.forward"))
                                            .foregroundColor(.earthyGold)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color.earthyGold)
                            
                            Group {
                                Text("Logins")
                                    .font(.title2.bold())
                                
                                Button("Log out") {
                                    appState = .loading
                                    authViewModel.signOut() { result in
                                        switch result {
                                        case .success():
                                            appState = .null
                                            isShowSettings = false
                                        case .failure(let error):
                                            alertTitle = "ERROR"
                                            alertMessage = error.localizedDescription
                                            appState = .alert
                                        }
                                    }
                                }
                                .font(.title3)
                                .foregroundColor(.lightBrown)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color.earthyGold)
                        }
                    }
                }
                .navigationBarHidden(true)
                .foregroundColor(.white)
                .background(Color.backgroundColor)
            }
        }
        .transition(.move(edge: .trailing))
    }
}
