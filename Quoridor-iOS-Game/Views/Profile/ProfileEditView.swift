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
    @State private var age: Double = 18
    @State private var isConfirming = false
    @State private var isDesignAvatar = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showProgressView = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button {
                        isEditProfile = false
                    } label: {
                        Text("Cancel")
                            .font(.title3)
                    }
                    
                    Spacer()
                    
                    Button {
                        showProgressView = true
                        authViewModel.updateUser(name: name, email: email, avatar: nil) { result in
                            switch result {
                            case .success():
                                playerViewModel.updatePlayer(name: name, email: email, zodiacSign: zodiacSign, age: Int(age), avatar: nil) { result in
                                    switch result {
                                    case .success():
                                        showProgressView = false
                                        isEditProfile = false
                                    case .failure(let error):
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    }
                                }
                            case .failure(let error):
                                alertMessage = error.localizedDescription
                                showAlert = true
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
                                    Text(zodiacSign.description)
                                }
                            } label: {}
                        } label: {
                            Text(zodiacSign.description)
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
                            Text("Age")
                            Spacer()
                        }
                        .padding(.leading)
                        .frame(width: geometry.size.width/3)
                        
                        HStack {
                            Text("\(Int(age)) years old")
                            Spacer()
                        }
                        .frame(width: geometry.size.width/3*2)
                    }
                    .padding(.vertical, 10)
                    .font(.title3)
                    
                    Slider(value: $age, in: 1...100, step: 1) {
                        Text("age")
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("100")
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
                age = Double(playerViewModel.currentPlayer.age)
            }
            .sheet(isPresented: $isDesignAvatar) {
                AvatarDesignView(authViewModel: authViewModel, playerViewModel: playerViewModel, isDesignAvatar: $isDesignAvatar)
            }
            .confirmationDialog("Change profile photo", isPresented: $isConfirming) {
                Button("Remove current photo") {
                    let currentPlayer = playerViewModel.currentPlayer
                    authViewModel.updateUser(name: currentPlayer.name, email: currentPlayer.email, avatar: URL(string: "https://firebasestorage.googleapis.com/v0/b/quoridor-ios-game.appspot.com/o/default.png?alt=media&token=d56342e8-76c0-4083-9a99-8c3f96d238b6")) { result in
                        if case .failure(let error) = result {
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                    playerViewModel.updatePlayer(name: currentPlayer.name, email: currentPlayer.email, zodiacSign: currentPlayer.zodiacSign, age: currentPlayer.age, avatar: URL(string: "https://firebasestorage.googleapis.com/v0/b/quoridor-ios-game.appspot.com/o/default.png?alt=media&token=d56342e8-76c0-4083-9a99-8c3f96d238b6")) { result in
                        if case .failure(let error) = result {
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                    playerViewModel.deleteAvatar() { result in
                        if case .failure(let error) = result {
                            alertMessage = error.localizedDescription
                            showAlert = true
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
        }
    }
}
