//
//  AccountView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/5.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var isShowSettings: Bool
    
    var body: some View {
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
                Text("Account")
                    .font(.title2.bold())
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 1)
                .overlay(Color.earthyGold)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        NavigationLink {
                            
                        } label: {
                            HStack(spacing: 10) {
                                Text("Personal information")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text(Image(systemName: "chevron.forward"))
                                    .foregroundColor(.earthyGold)
                            }
                        }
                        
                        NavigationLink {
                            
                        } label: {
                            HStack(spacing: 10) {
                                Text("Avatar")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text(Image(systemName: "chevron.forward"))
                                    .foregroundColor(.earthyGold)
                            }
                        }
                        
                        NavigationLink {
                            ConnectsView(authViewModel: authViewModel, playerViewModel: playerViewModel)
                        } label: {
                            HStack(spacing: 10) {
                                Text("Connects")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text(Image(systemName: "chevron.forward"))
                                    .foregroundColor(.earthyGold)
                            }
                        }
                        
                        NavigationLink {
                            DeleteAccountView(authViewModel: authViewModel, playerViewModel: playerViewModel, isShowSettings: $isShowSettings)
                        } label: {
                            HStack(spacing: 10) {
                                Text("Delete account")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text(Image(systemName: "chevron.forward"))
                                    .foregroundColor(.earthyGold)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
            }
        }
        .navigationBarHidden(true)
        .foregroundColor(.white)
        .background(Color.backgroundColor)
    }
}
