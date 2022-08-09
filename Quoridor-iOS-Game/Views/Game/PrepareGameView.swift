//
//  PrepareGameView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/16.
//

import SwiftUI

struct PrepareGameView: View {
    
    @ObservedObject var playerViewModel: PlayerViewModel
    @ObservedObject var gameViewModel: GameViewModel
    
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 25) {
                HStack {
                    Button {
                        appState = .loading
                        gameViewModel.exitRoom(player: playerViewModel.currentPlayer) { result in
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
                        Text(Image(systemName: "arrow.backward.circle"))
                            .font(.largeTitle)
                            .foregroundColor(.lightBrown)
                    }
                    
                    (Text(gameViewModel.game.gameType.symbol) + Text(" Room ID \(gameViewModel.game.id ?? "loading")"))
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .foregroundColor(.white)
                        .background {
                            Capsule()
                                .foregroundColor(gameViewModel.game.gameType.foregroundColor)
                        }
                }
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(spacing: 10) {
                            HStack {
                                Text("Room Owner")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            
                            HStack {
                                AsyncImage(url: gameViewModel.game.roomOwner?.avatar) { image in
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
                                .padding(.trailing, 25)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(gameViewModel.game.roomOwner?.name ?? "")
                                        .font(.title.bold())
                                    
                                    HStack {
                                        Text("Star \(gameViewModel.game.roomOwner?.star ?? 0)")
                                            .bold()
                                            .padding(.horizontal, 10)
                                            .foregroundColor(gameViewModel.game.gameType.foregroundColor)
                                            .background {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .foregroundColor(.white)
                                            }
                                        
                                        Text("Win Rate \(gameViewModel.game.roomOwner?.winRate ?? Double(0), specifier: "%.1f") %")
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(15)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(gameViewModel.game.gameType.foregroundColor)
                            }
                        }
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(gameViewModel.game.gameType.foregroundColor.opacity(0.5))
                        }
                        
                        VStack(spacing: 10) {
                            HStack {
                                if gameViewModel.game.joinedPlayer == nil {
                                    Text("Invite your friend to join")
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                } else {
                                    Text(gameViewModel.game.isReadyToPlay ? "Already to play" : "Preparing...")
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                            }
                            
                            HStack {
                                AsyncImage(url: gameViewModel.game.joinedPlayer?.avatar) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: geometry.size.width/4, height: geometry.size.width/4)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.trailing, 25)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(gameViewModel.game.joinedPlayer?.name ?? "")
                                        .font(.title.bold())
                                    
                                    if gameViewModel.game.joinedPlayer != nil {
                                        HStack {
                                            Text("Star \(gameViewModel.game.joinedPlayer?.star ?? 0)")
                                                .bold()
                                                .padding(.horizontal, 10)
                                                .foregroundColor(gameViewModel.game.gameType.foregroundColor)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .foregroundColor(.white)
                                                }
                                            
                                            Text("Win Rate \(gameViewModel.game.joinedPlayer?.winRate ?? Double(0), specifier: "%.1f") %")
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(15)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(gameViewModel.game.gameType.foregroundColor)
                            }
                        }
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(gameViewModel.game.gameType.foregroundColor.opacity(0.5))
                        }
                    }
                }
                
                Text(gameViewModel.game.joinedPlayer == nil ? "Let your friend join this game by room ID, or just start the game, we'll match a player for you." : gameViewModel.game.roomOwner?.email == playerViewModel.currentPlayer.email ? "You could start the game when another player has got ready." : gameViewModel.game.isReadyToPlay ? "Just wait for room owner to start the game." : "When you've got ready, press \"Ready to Play\" so that room owner could start the game.")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(gameViewModel.game.gameType.foregroundColor.opacity(0.5))
                    }
                
                if gameViewModel.game.roomOwner?.email == playerViewModel.currentPlayer.email {
                    Button {
                        if gameViewModel.game.joinedPlayer == nil {
                            appState = .matchGame
                            gameViewModel.changeGameStateToMatch() { result in
                                switch result {
                                case .success():
                                    gameViewModel.findMatchGame { result in
                                        if result == "found" {
                                            gameViewModel.joinMatchedRoom(player: playerViewModel.currentPlayer) { result in
                                                if result == "success" {
                                                    if gameViewModel.game.gameType == .rank {
                                                        playerViewModel.pay200(player: gameViewModel.game.roomOwner!) { result in
                                                            switch result {
                                                            case .success():
                                                                playerViewModel.pay200(player: gameViewModel.game.joinedPlayer!) { result in
                                                                    switch result {
                                                                    case .success():
                                                                        appState = .null
                                                                    case .failure(let error):
                                                                        alertTitle = "ERROR"
                                                                        alertMessage = error.localizedDescription
                                                                        appState = .alert
                                                                    }
                                                                }
                                                            case .failure(let error):
                                                                alertTitle = "ERROR"
                                                                alertMessage = error.localizedDescription
                                                                appState = .alert
                                                            }
                                                        }
                                                    } else {
                                                        appState = .null
                                                    }
                                                } else {
                                                    alertTitle = "ERROR"
                                                    alertMessage = result
                                                    appState = .alert
                                                }
                                            }
                                        } else if result != "not found" {
                                            alertTitle = "ERROR"
                                            alertMessage = result
                                            appState = .alert
                                        }
                                    }
                                case .failure(let error):
                                    alertTitle = "ERROR"
                                    alertMessage = error.localizedDescription
                                    appState = .alert
                                }
                            }
                        } else {
                            if gameViewModel.game.isReadyToPlay {
                                appState = .loading
                                gameViewModel.startTheGame { result in
                                    switch result {
                                    case .success():
                                        if gameViewModel.game.gameType == .rank {
                                            playerViewModel.pay200(player: gameViewModel.game.roomOwner!) { result in
                                                switch result {
                                                case .success():
                                                    playerViewModel.pay200(player: gameViewModel.game.joinedPlayer!) { result in
                                                        switch result {
                                                        case .success():
                                                            appState = .null
                                                        case .failure(let error):
                                                            alertTitle = "ERROR"
                                                            alertMessage = error.localizedDescription
                                                            appState = .alert
                                                        }
                                                    }
                                                case .failure(let error):
                                                    alertTitle = "ERROR"
                                                    alertMessage = error.localizedDescription
                                                    appState = .alert
                                                }
                                            }
                                        } else {
                                            appState = .null
                                        }
                                    case .failure(let error):
                                        alertTitle = "ERROR"
                                        alertMessage = error.localizedDescription
                                        appState = .alert
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Start the Game")
                            .font(.title.bold())
                            .foregroundColor(.lightBrown)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.lightBrown, lineWidth: 1.5)
                            }
                    }
                    .opacity(gameViewModel.game.joinedPlayer != nil && !gameViewModel.game.isReadyToPlay ? 0.8 : 1)
                    .disabled(gameViewModel.game.joinedPlayer != nil && !gameViewModel.game.isReadyToPlay)
                } else {
                    Button {
                        gameViewModel.toggleReadyToPlay() { result in
                            if case .failure(let error) = result {
                                alertTitle = "ERROR"
                                alertMessage = error.localizedDescription
                                appState = .alert
                            }
                        }
                    } label: {
                        if gameViewModel.game.isReadyToPlay {
                            Text("Waiting")
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(gameViewModel.game.gameType.foregroundColor)
                                }
                        } else {
                            Text("Ready to Play")
                                .font(.title.bold())
                                .foregroundColor(.lightBrown)
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.lightBrown, lineWidth: 1.5)
                                }
                        }
                    }
                }
            }
        }
    }
}
