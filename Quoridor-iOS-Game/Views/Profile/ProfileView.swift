//
//  ProfileView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/1.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    @State private var isEditProfile = false
    
    let geometry: GeometryProxy
    
    var body: some View {
        ScrollView {
            Button {
                isEditProfile = true
            } label: {
                HStack {
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
                    .frame(width: geometry.size.width/4, height: geometry.size.width/4)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.trailing)
                    
                    ZStack(alignment: .topTrailing) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(playerViewModel.currentPlayer.name)
                                    .font(.title.bold())
                                
                                Text("Joined \(playerViewModel.currentPlayer.joined.formatted(date: .abbreviated, time: .omitted))")
                            }
                            
                            Spacer()
                        }
                        .frame(height: geometry.size.width/4)
                        
                        Text(Image(systemName: "highlighter"))
                            .bold()
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.roseGold)
                }
            }
            
            HStack {
                Group {
                    VStack(spacing: 5) {
                        Text("\(playerViewModel.currentPlayer.played)")
                            .font(.title2.bold())
                        
                        Text("Played")
                    }
                    
                    VStack(spacing: 5) {
                        Text("\(playerViewModel.currentPlayer.winRate, specifier: "%.1f") %")
                            .font(.title2.bold())
                        
                        Text("Win Rate")
                    }
                    
                    VStack(spacing: 5) {
                        Text("\(playerViewModel.currentPlayer.maxStar)")
                            .font(.title2.bold())
                        
                        Text("Max Star")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.roseGold, lineWidth: 2.5)
            }
            .padding(.vertical)
            
            VStack {
                HStack {
                    Text("About You")
                        .font(.title3.bold())
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color.roseGold)
                
                Group {
                    HStack {
                        Text("Age")
                            .bold()
                        
                        Spacer()
                        
                        Text("\(playerViewModel.currentPlayer.age)")
                    }
                    .padding(.top, 5)
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(Color.earthyGold)
                        .padding(.vertical, 5)
                    
                    HStack {
                        Text("Zodiac Sign")
                            .bold()
                        
                        Spacer()
                        
                        Text(LocalizedStringKey(playerViewModel.currentPlayer.zodiacSign.description))
                    }
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(Color.earthyGold)
                        .padding(.vertical, 5)
                    
                    HStack {
                        Text("Email")
                            .bold()
                        
                        Spacer()
                        
                        Text(playerViewModel.currentPlayer.email)
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
            }
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.roseGold, lineWidth: 2.5)
            }
        }
        .padding(.vertical)
        .sheet(isPresented: $isEditProfile) {
            ProfileEditView(authViewModel: authViewModel, playerViewModel: playerViewModel, isEditProfile: $isEditProfile, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage)
        }
    }
}
