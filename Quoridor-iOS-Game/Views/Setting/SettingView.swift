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
    
    @Binding var isShowSettings: Bool
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showProgressView = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Button {
                            isShowSettings = false
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
                                    AccountView(authViewModel: authViewModel, playerViewModel: playerViewModel, isShowSettings: $isShowSettings)
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
                                    showProgressView = true
                                    authViewModel.signOut() { result in
                                        switch result {
                                        case .success():
                                            isShowSettings = false
                                        case .failure(let error):
                                            alertMessage = error.localizedDescription
                                            showAlert = true
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
                .overlay {
                    if showProgressView {
                        Color.white
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity)
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
                .background(Color.backgroundColor)
            }
        }
        .transition(.move(edge: .trailing))
        .animation(.default, value: isShowSettings)
    }
}
