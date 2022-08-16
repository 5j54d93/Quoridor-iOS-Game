//
//  ProfileEditView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/1.
//

import SwiftUI

struct ProfileEditView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var isEditProfile: Bool

    @State private var name = "Loading..."
    @State private var email = "Loading..."
    @State private var zodiacSign = Player.zodiacSignType.notSet
    @State private var birthYear = Double(Calendar.current.component(.year, from: Date()) - 18)
    @State private var isConfirming = false
    @State private var isDesignAvatar = false
    
    @State private var isLoading = false
    @State private var isAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button {
                        isEditProfile = false
                    } label: {
                        Text("Cancel")
                            .font(.title3)
                            .opacity(0.85)
                    }
                    
                    Spacer()
                    
                    Button {
                        isLoading = true
                        authViewModel.updateUser(name: name, email: email, avatar: nil) { result in
                            switch result {
                            case .success():
                                playerViewModel.updatePlayer(name: name, email: email, zodiacSign: zodiacSign, birthYear: Int(birthYear), avatar: nil) { result in
                                    switch result {
                                    case .success():
                                        isLoading = false
                                        isEditProfile = false
                                    case .failure(let error):
                                        alertTitle = "ERROR"
                                        alertMessage = error.localizedDescription
                                        isAlert = true
                                    }
                                }
                            case .failure(let error):
                                alertTitle = "ERROR"
                                alertMessage = error.localizedDescription
                                isAlert = true
                            }
                        }
                    } label: {
                        Text("Done")
                            .font(.title3.bold())
                            .foregroundColor(.lightBrown)
                    }
                }
                .overlay {
                    Text("Edit Profile")
                        .font(.title2.bold())
                }
                .padding(.top)
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.earthyGold)
                
                Group {
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
                    .frame(width: geometry.size.width/3, height: geometry.size.width/3)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.top)
                    
                    Button {
                        isConfirming = true
                    } label: {
                        Text("Change profile photo")
                            .bold()
                            .foregroundColor(.lightBrown)
                    }
                    .padding(.vertical, 10)
                }
                
                Divider()
                    .frame(height: 0.6)
                    .overlay(Color.earthyGold)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Name")
                            .padding(.vertical, 10)
                        
                        Divider()
                            .hidden()
                        
                        Text("Email")
                            .padding(.vertical, 10)
                            .opacity(authViewModel.providers.contains("password") ? 1 : 0.65)
                        
                        Divider()
                            .hidden()
                        
                        Text("Zodiac Sign")
                            .padding(.vertical, 10)
                    }
                    .font(.title3)
                    .padding(.leading)
                    .frame(width: geometry.size.width/3)
                    
                    VStack(alignment: .leading) {
                        TextField("Name", text: $name, prompt: Text("Name"))
                            .disableAutocorrection(true)
                            .padding(.vertical, 10)
                        
                        Divider()
                            .frame(height: 0.6)
                            .overlay(Color.earthyGold)
                        
                        TextField("Email", text: $email, prompt: Text("Email"))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.vertical, 10)
                            .disabled(!authViewModel.providers.contains("password"))
                            .opacity(authViewModel.providers.contains("password") ? 1 : 0.65)
                        
                        Divider()
                            .frame(height: 0.6)
                            .overlay(Color.earthyGold)
                        
                        Menu {
                            Picker(selection: $zodiacSign) {
                                ForEach(Player.zodiacSignType.allCases, id: \.self) { zodiacSign in
                                    Text(LocalizedStringKey(zodiacSign.description))
                                }
                            } label: {}
                        } label: {
                            Text(LocalizedStringKey(zodiacSign.description))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 10)
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width*2/3)
                }
                
                Divider()
                    .frame(height: 0.6)
                    .overlay(Color.earthyGold)
                
                Group {
                    HStack {
                        HStack {
                            Text("Birth Year")
                            Spacer()
                        }
                        .padding(.leading)
                        .frame(width: geometry.size.width/3)
                        
                        HStack {
                            Text("\(Int(birthYear))")
                            Spacer()
                        }
                        .frame(width: geometry.size.width/3*2)
                    }
                    .padding(.vertical, 10)
                    .font(.title3)
                    
                    Slider(value: $birthYear, in: Double(Calendar.current.component(.year, from: Date()) - 100)...Double(Calendar.current.component(.year, from: Date())), step: 1) {
                        Text("Birth Year")
                    } minimumValueLabel: {
                        Text("\(Calendar.current.component(.year, from: Date()) - 100)")
                    } maximumValueLabel: {
                        Text("\(Calendar.current.component(.year, from: Date()))")
                    }
                    .tint(.lightBrown)
                    .padding(.horizontal)
                }
                
                Divider()
                    .frame(height: 0.6)
                    .overlay(Color.earthyGold)
                
                Spacer()
            }
            .background(Color.backgroundColor)
            .onAppear {
                name = playerViewModel.currentPlayer.name
                email = playerViewModel.currentPlayer.email
                zodiacSign = playerViewModel.currentPlayer.zodiacSign
                birthYear = Double(playerViewModel.currentPlayer.birthYear)
            }
            .sheet(isPresented: $isDesignAvatar) {
                AvatarDesignView(authViewModel: authViewModel, playerViewModel: playerViewModel, isDesignAvatar: $isDesignAvatar)
            }
            .confirmationDialog("Change profile photo", isPresented: $isConfirming) {
                Button("Remove current photo") {
                    isLoading = true
                    let currentPlayer = playerViewModel.currentPlayer
                    authViewModel.updateUser(name: currentPlayer.name, email: currentPlayer.email, avatar: URL(string: "https://firebasestorage.googleapis.com/v0/b/quoridor-ios-game.appspot.com/o/default.png?alt=media&token=d56342e8-76c0-4083-9a99-8c3f96d238b6")) { result in
                        switch result {
                        case .success():
                            playerViewModel.updatePlayer(name: currentPlayer.name, email: currentPlayer.email, zodiacSign: currentPlayer.zodiacSign, birthYear: currentPlayer.birthYear, avatar: URL(string: "https://firebasestorage.googleapis.com/v0/b/quoridor-ios-game.appspot.com/o/default.png?alt=media&token=d56342e8-76c0-4083-9a99-8c3f96d238b6")) { result in
                                switch result {
                                case .success():
                                    playerViewModel.deleteAvatar() { result in
                                        switch result {
                                        case .success():
                                            isLoading = false
                                        case .failure(let error):
                                            alertTitle = "ERROR"
                                            alertMessage = error.localizedDescription
                                            isAlert = true
                                        }
                                    }
                                case .failure(let error):
                                    alertTitle = "ERROR"
                                    alertMessage = error.localizedDescription
                                    isAlert = true
                                }
                            }
                        case .failure(let error):
                            alertTitle = "ERROR"
                            alertMessage = error.localizedDescription
                            isAlert = true
                        }
                    }
                }
                
                Button("Choose from library") {
                    
                }
                
                Button("Create avatar") {
                    isDesignAvatar = true
                }
            }
            .overlay {
                LoadingView(isLoading: $isLoading, isAlert: $isAlert, alertTitle: $alertTitle, alertMessage: $alertMessage, geometry: geometry)
            }
        }
    }
}
