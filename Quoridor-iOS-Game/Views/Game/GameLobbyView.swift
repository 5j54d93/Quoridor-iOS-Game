//
//  GameLobbyView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/15.
//

import SwiftUI

struct GameLobbyView: View {
    
    @ObservedObject var playerViewModel: PlayerViewModel
    @ObservedObject var gameViewModel: GameViewModel
    
    @StateObject var adModViewModel = AdModViewModel()
    
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button {
                    if playerViewModel.currentPlayer.played != 0 && playerViewModel.currentPlayer.played % 4 == 0 && !playerViewModel.currentPlayer.haveGottenReward {
                        appState = .loading
                        playerViewModel.getReward(haveGottenReward: true) { result in
                            switch result {
                            case .success(let reward):
                                alertTitle = "Congratulation!"
                                alertMessage = "You get $\(reward) money."
                                appState = .alert
                            case .failure(let error):
                                alertTitle = "ERROR"
                                alertMessage = error.localizedDescription
                                appState = .alert
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: playerViewModel.currentPlayer.played != 0 && playerViewModel.currentPlayer.played % 4 == 0 && !playerViewModel.currentPlayer.haveGottenReward ? "gift.fill" : "gift")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 25)
                        
                        VStack(alignment: .leading) {
                            Text("Game Reward")
                                .font(.title.bold())
                            
                            Spacer()
                            
                            HStack {
                                if playerViewModel.currentPlayer.played % 4 == 0 {
                                    ForEach(1...4, id: \.self) { index in
                                        Capsule()
                                    }
                                } else {
                                    ForEach(1...4, id: \.self) { index in
                                        Capsule()
                                            .foregroundColor(playerViewModel.currentPlayer.played % 4 >= index ? .lightBrown : .white)
                                    }
                                }
                            }
                            .frame(height: 8)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(20)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(
                                playerViewModel.currentPlayer.played != 0 && playerViewModel.currentPlayer.played % 4 == 0 && !playerViewModel.currentPlayer.haveGottenReward
                                ? .lightBrown
                                : .white.opacity(0.33)
                            )
                    }
                    .onAppear {
                        if playerViewModel.currentPlayer.played % 4 != 0 && playerViewModel.currentPlayer.haveGottenReward {
                            playerViewModel.getReward(haveGottenReward: false) { result in
                                if case .failure(let error) = result {
                                    alertTitle = "ERROR"
                                    alertMessage = error.localizedDescription
                                    appState = .alert
                                }
                            }
                        }
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        withAnimation {
                            alertTitle = "Hint"
                            alertMessage = "You can get random money from $1 to $200 every 4 games."
                            appState = .alert
                        }
                    } label: {
                        Text(Image(systemName: "questionmark.circle"))
                            .font(.title2.bold())
                            .padding([.top, .trailing], 10)
                    }
                }
                
                Button {
                    withAnimation {
                        appState = .loading
                        gameViewModel.createRoom(gameType: .rank, player: playerViewModel.currentPlayer) { result in
                            if result == "success" {
                                appState = .null
                            } else {
                                alertTitle = "ERROR"
                                alertMessage = result
                                appState = .alert
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "flag.filled.and.flag.crossed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.trailing, 25)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Create a Game")
                                .font(.title.bold())
                            
                            HStack {
                                Text("Rank")
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .foregroundColor(.roseGold)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(.white)
                                    }
                                
                                Text("Cost : $200")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(25)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.roseGold)
                    }
                }
                
                Button {
                    withAnimation {
                        appState = .loading
                        gameViewModel.createRoom(gameType: .casual, player: playerViewModel.currentPlayer) { result in
                            if result == "success" {
                                appState = .null
                            } else {
                                alertTitle = "ERROR"
                                alertMessage = result
                                appState = .alert
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.trailing, 25)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Create a Game")
                                .font(.title.bold())
                            
                            HStack {
                                Text("Casual")
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .foregroundColor(.earthyGold)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(.white)
                                    }
                                
                                Text("Cost Free")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(25)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.earthyGold)
                    }
                }
                
                Button {
                    withAnimation {
                        appState = .joinGame
                    }
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.trailing, 25)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Join a Game")
                                .font(.title.bold())
                            
                            HStack {
                                Text("By Room ID")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(25)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.middleBrown)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        alertTitle = "Hint"
                        alertMessage = "Join a game may need to cost $200 if it's created for rank, and if your money is less than $200, we couldn't let you in."
                        appState = .alert
                    } label: {
                        Text(Image(systemName: "questionmark.circle"))
                            .font(.title2.bold())
                            .padding([.top, .trailing], 10)
                    }
                }
                
                if playerViewModel.currentPlayer.lastAdPlayed == nil || playerViewModel.currentPlayer.lastAdPlayed?.formatted(date: .abbreviated, time: .omitted) != Date().formatted(date: .abbreviated, time: .omitted) {
                    Button {
                        if adModViewModel.ad != nil {
                            adModViewModel.showAd { result in
                                if result == "success" {
                                    playerViewModel.get200 { result in
                                        switch result {
                                        case .success():
                                            alertTitle = "Congratulation!"
                                            alertMessage = "You get $200 money."
                                            appState = .alert
                                        case .failure(let error):
                                            alertTitle = "ERROR"
                                            alertMessage = error.localizedDescription
                                            appState = .alert
                                        }
                                    }
                                } else {
                                    alertTitle = "ERROR"
                                    alertMessage = result
                                    appState = .alert
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "play.tv.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(.trailing, 25)
                            
                            VStack(alignment: .leading) {
                                Text("Watch Video")
                                    .font(.title.bold())
                                
                                Spacer()
                                
                                Text("Get : $200")
                                    .frame(height: 8)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(20)
                        .foregroundColor(.lightBrown)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.lightBrown, lineWidth: 2.5)
                        }
                    }
                    .onAppear {
                        adModViewModel.loadAd()
                    }
                }
            }
            .padding(.vertical, 15)
        }
    }
}
