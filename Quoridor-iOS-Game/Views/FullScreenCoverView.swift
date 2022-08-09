//
//  FullScreenCoverView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/6.
//

import SwiftUI
import AVFoundation

struct FullScreenCoverView: View {
    
    @AppStorage("vibration") var vibration = true
    @AppStorage("backgroundMusicVolume") var backgroundMusicVolume = 0.5
    @AppStorage("soundEffectVolume") var soundEffectVolume = 0.5
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    @ObservedObject var gameViewModel: GameViewModel
    
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    enum KeyboardType: CaseIterable {
        case nine, eight, seven, six, five, four, three, two, one, delete, zero, enter
        
        var TextView: Text {
            switch self {
            case .nine: return Text("9")
            case .eight: return Text("8")
            case .seven: return Text("7")
            case .six: return Text("6")
            case .five: return Text("5")
            case .four: return Text("4")
            case .three: return Text("3")
            case .two: return Text("2")
            case .one: return Text("1")
            case .delete: return Text(Image(systemName: "delete.left.fill"))
            case .zero: return Text("0")
            case .enter: return Text("Enter")
            }
        }
        var description: String {
            switch self {
            case .nine: return "9"
            case .eight: return "8"
            case .seven: return "7"
            case .six: return "6"
            case .five: return "5"
            case .four: return "4"
            case .three: return "3"
            case .two: return "2"
            case .one: return "1"
            case .delete: return "delete"
            case .zero: return "0"
            case .enter: return "enter"
            }
        }
    }
    
    @State private var roomId = ""
    
    let geometry: GeometryProxy
    
    var body: some View {
        if appState != .null {
                Color.white
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if [.alert, .joinGame, .gameSetting, .giveUpGame].contains(appState) {
                            appState = .null
                        }
                    }
                
                switch appState {
                case .loading:
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(3)
                            .progressViewStyle(CircularProgressViewStyle(tint: .roseGold))
                        
                        Text("Loading...")
                            .font(.title3)
                            .padding(.top, 15)
                            .foregroundColor(.roseGold)
                    }
                case .alert, .giveUpGame:
                    VStack(spacing: 20) {
                        Text(LocalizedStringKey(alertTitle))
                            .font(.title.bold())
                            .foregroundColor(.roseGold)
                        
                        Text(LocalizedStringKey(alertMessage))
                            .foregroundColor(.roseGold)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            if appState == .alert {
                                appState = .null
                            } else {
                                gameViewModel.giveUp(player: playerViewModel.currentPlayer) { result in
                                    if case .failure(let error) = result {
                                        alertTitle = "ERROR"
                                        alertMessage = error.localizedDescription
                                        appState = .alert
                                    }
                                }
                            }
                        } label: {
                            Text(appState == .alert ? "OK" : "YES")
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
                case .joinGame:
                    VStack(spacing: 20) {
                        Text(LocalizedStringKey(roomId.isEmpty ? "Room ID" : roomId))
                            .font(roomId.isEmpty ? .title : .title.bold())
                            .foregroundColor(roomId.isEmpty ? .gray : .darkBrown)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.roseGold, lineWidth: 2)
                            }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10) {
                            ForEach(KeyboardType.allCases, id: \.self) { key in
                                GeometryReader { geo in
                                    Button {
                                        switch key {
                                        case .delete:
                                            roomId = roomId.dropLast().description
                                        case .enter:
                                            appState = .loading
                                            gameViewModel.joinRoom(roomId: roomId, player: playerViewModel.currentPlayer) { result in
                                                if result == "success" {
                                                    appState = .null
                                                    roomId = ""
                                                } else {
                                                    alertTitle = "ERROR"
                                                    alertMessage = result
                                                    appState = .alert
                                                }
                                            }
                                        default:
                                            roomId += key.description
                                        }
                                    } label: {
                                        key.TextView
                                            .font(.title.bold())
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: geo.size.width)
                                            .background {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .foregroundColor(.roseGold)
                                            }
                                    }
                                }
                                .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                    .padding(20)
                    .frame(width: geometry.size.width*0.8)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                    }
                case .matchGame:
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(3)
                            .progressViewStyle(CircularProgressViewStyle(tint: .roseGold))
                        
                        Text("We're matching a player for you now, please wait...")
                            .foregroundColor(.roseGold)
                            .frame(width: geometry.size.width*0.8)
                            .multilineTextAlignment(.center)
                            .padding(.top, 15)
                        
                        Button {
                            gameViewModel.cancelMatching { result in
                                switch result {
                                case .success():
                                    appState = .null
                                case .failure(let error):
                                    alertTitle = "ERROR"
                                    alertMessage = error.localizedDescription
                                    appState = .alert
                                }
                            }
                        } label: {
                            Text("CANCEL")
                                .font(.title3.bold())
                                .foregroundColor(.roseGold)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background {
                                    Capsule()
                                        .stroke(Color.roseGold, lineWidth: 1.5)
                                }
                        }
                    }
                    .onChange(of: gameViewModel.game.gameState) { gameState in
                        if gameState == .playing {
                            appState = .null
                        }
                    }
                case .gameSetting :
                    VStack(spacing: 0) {
                        Text("Game Settings")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.roseGold)
                        
                        VStack(spacing: 20) {
                            Toggle(isOn: $vibration) {
                                Text("Vibrate")
                                    .font(.title3.bold())
                                    .foregroundColor(.roseGold)
                            }
                            .tint(.lightBrown)
                            
                            VStack(spacing: 6) {
                                HStack {
                                    Text("Background Music")
                                        .font(.title3.bold())
                                    
                                    Spacer()
                                    
                                    Text(Image(systemName: backgroundMusicVolume == 0 ? "speaker.slash" : backgroundMusicVolume < 0.3 ? "speaker" : backgroundMusicVolume < 0.6 ? "speaker.wave.1" : backgroundMusicVolume < 1 ? "speaker.wave.2" : "speaker.wave.3"))
                                        .font(.title2)
                                }
                                .foregroundColor(.roseGold)
                                
                                Slider(value: $backgroundMusicVolume, in: 0...1, step: 0.1) {
                                    Text("volume")
                                } minimumValueLabel: {
                                    Text("Low")
                                } maximumValueLabel: {
                                    Text("High")
                                }
                                .tint(.lightBrown)
                                .foregroundColor(.roseGold)
                                .onChange(of: backgroundMusicVolume) { newVolume in
                                    AVPlayer.bgQueuePlayer.volume = Float(newVolume)
                                }
                            }
                            
                            VStack(spacing: 6) {
                                HStack {
                                    Text("Sound Effect")
                                        .font(.title3.bold())
                                
                                    Spacer()
                                    
                                    Text(Image(systemName: soundEffectVolume == 0 ? "speaker.slash" : soundEffectVolume < 0.3 ? "speaker" : soundEffectVolume < 0.6 ? "speaker.wave.1" : soundEffectVolume < 1 ? "speaker.wave.2" : "speaker.wave.3"))
                                        .font(.title2)
                                }
                                .foregroundColor(.roseGold)
                                
                                Slider(value: $soundEffectVolume, in: 0...1, step: 0.1) {
                                    Text("volume")
                                } minimumValueLabel: {
                                    Text("Low")
                                } maximumValueLabel: {
                                    Text("High")
                                }
                                .tint(.lightBrown)
                                .foregroundColor(.roseGold)
                                .onChange(of: soundEffectVolume) { newVolume in
                                    gameViewModel.setVolume(volume: Float(newVolume))
                                }
                            }
                            
                            Button {
                                alertTitle = "Give Up?"
                                alertMessage = "You're going to give up this game"
                                appState = .giveUpGame
                            } label: {
                                Text("Give Up")
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
                    }
                    .frame(width: geometry.size.width*0.8)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                    }
                case .endGame:
                    VStack(spacing: 20) {
                        Text(gameViewModel.game.winner?.email == playerViewModel.currentPlayer.email ? "YOU WIN" : "YOU LOSE")
                            .font(.title.bold())
                            .foregroundColor(.roseGold)
                        
                        if gameViewModel.game.gameType == .rank {
                            VStack(spacing: 10) {
                                HStack(spacing: 6) {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .background(Color.white.clipShape(Circle()))
                                    
                                    Text("\(gameViewModel.game.winner?.email == playerViewModel.currentPlayer.email ? playerViewModel.currentPlayer.money - 200 : playerViewModel.currentPlayer.money + 200)")
                                    
                                    Text(Image(systemName: "line.diagonal.arrow"))
                                        .rotationEffect(.degrees(45))
                                        .padding(.horizontal, 6)
                                    
                                    Image(systemName: "dollarsign.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .background(Color.white.clipShape(Circle()))
                                    
                                    Text("\(playerViewModel.currentPlayer.money)")
                                }
                                .foregroundColor(.roseGold)
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "star.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .background(Color.white.clipShape(Circle()))
                                    
                                    Text("\(playerViewModel.currentPlayer.star == 0 ? 0 : gameViewModel.game.winner?.email == playerViewModel.currentPlayer.email ? playerViewModel.currentPlayer.star - 1 : playerViewModel.currentPlayer.star + 1)")
                                    
                                    Text(Image(systemName: "line.diagonal.arrow"))
                                        .rotationEffect(.degrees(45))
                                        .padding(.horizontal, 6)
                                    
                                    Image(systemName: "star.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .background(Color.white.clipShape(Circle()))
                                    
                                    Text("\(playerViewModel.currentPlayer.star)")
                                }
                                .foregroundColor(.roseGold)
                            }
                        }
                        
                        Button {
                            appState = .loading
                            gameViewModel.exitGame(player: playerViewModel.currentPlayer) { result in
                                switch result {
                                case .success():
                                    appState = .null
                                case .failure(let error):
                                    alertTitle = "ERROR"
                                    alertMessage = error.localizedDescription
                                    appState = .alert
                                }
                            }
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
                    .onAppear {
                        if vibration {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(gameViewModel.game.winner?.email == playerViewModel.currentPlayer.email ? .success : .error)
                        }
                    }
                default:
                    EmptyView()
                }
        }
    }
}
