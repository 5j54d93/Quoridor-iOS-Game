//
//  DeleteAccountView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/8.
//

import SwiftUI

struct DeleteAccountView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var isShowSettings: Bool
    
    @State private var isShowAlert = false
    @State private var isDeletingAccount = false
    @State private var isShowDeleteAccountAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(Image(systemName: "chevron.backward"))
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                }
                .overlay {
                    Text("Delete account")
                        .font(.title2.bold())
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.earthyGold)
                
                ScrollView {
                    VStack {
                        AsyncImage(url: playerViewModel.currentPlayer.avatar) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray
                                .overlay {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .lightBrown))
                                }
                        }
                        .frame(width: geometry.size.width*0.35, height: geometry.size.width*0.35)
                        .clipShape(Circle())
                        .padding(.top)
                        
                        Text("Deleting your account ?")
                            .font(.title.bold())
                            .padding(.vertical)
                        
                        HStack(alignment: .top, spacing: 15) {
                            Text(Image(systemName: "exclamationmark.triangle"))
                                .font(.title)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Deleting your account is permanent")
                                    .font(.title3.bold())
                                
                                Text("Your profile, money, star, game data will be permanently deleted.")
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.earthyGold)
                
                Button {
                    isShowAlert = true
                } label: {
                    Text("Delete account")
                        .font(.title3.bold())
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.roseGold)
                        }
                }
                .padding(.top, 5)
                .padding(.bottom, 12)
                .padding(.horizontal)
            }
            .overlay {
                if isShowAlert {
                    Color.white
                        .ignoresSafeArea()
                        .opacity(0.7)
                    
                    if !isDeletingAccount {
                        if !isShowDeleteAccountAlert {
                            VStack {
                                Text("Delete your Quoridor account?")
                                    .multilineTextAlignment(.center)
                                    .font(.title2.bold())
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                
                                Text("You're requesting to delete your account")
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                
                                Divider()
                                    .frame(height: 0.5)
                                    .overlay(Color.earthyGold)
                                
                                Button {
                                    isDeletingAccount = true
                                    playerViewModel.deleteAvatar() { result in
                                        if case .failure(let error) = result {
                                            alertMessage = error.localizedDescription
                                            isShowDeleteAccountAlert = true
                                        }
                                    }
                                    playerViewModel.deleteUser()
                                    authViewModel.deleteUser { result in
                                        switch result {
                                        case .success():
                                            isShowSettings = false
                                        case .failure(let error):
                                            alertMessage = error.localizedDescription
                                            isShowDeleteAccountAlert = true
                                        }
                                    }
                                } label: {
                                    Text("Continue deleting account")
                                        .font(.title2.bold())
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity)
                                }
                                
                                Divider()
                                    .frame(height: 0.5)
                                    .overlay(Color.earthyGold)
                                
                                Button {
                                    isShowAlert = false
                                } label: {
                                    Text("Cancel")
                                        .font(.title2)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.vertical, 10)
                            .foregroundColor(.backgroundColor)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                            }
                            .frame(width: geometry.size.width*0.85)
                        } else {
                            VStack(spacing: 20) {
                                Text(alertMessage)
                                    .foregroundColor(.roseGold)
                                
                                Button {
                                    isShowAlert = false
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
                    } else {
                        ProgressView()
                            .scaleEffect(3)
                            .progressViewStyle(CircularProgressViewStyle(tint: .roseGold))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .foregroundColor(.white)
        .background(Color.backgroundColor)
    }
}
