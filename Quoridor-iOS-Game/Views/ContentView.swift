//
//  ContentView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/6/28.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var playerViewModel = PlayerViewModel()
    @StateObject var gameViewModel = GameViewModel()
    
    enum TabType: CaseIterable {
        case leaderBoard, game, profile
        
        var systemName: String {
            switch self {
            case .leaderBoard: return "chart.bar"
            case .game: return "gamecontroller"
            case .profile: return "person.crop.circle"
            }
        }
    }
    enum AppStateType { case null, alert, loading, joinGame, matchGame, gameSetting, giveUpGame, endGame }
    
    @State private var appState: AppStateType = .null
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var hadTouchedScreen = false
    @State private var selectTab: TabType = .game
    @State private var isShowSettings = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if authViewModel.currentUser != nil {
                    if hadTouchedScreen {
                        VStack {
                            switch gameViewModel.game.gameState {
                            case .unCreate:
                                VStack {
                                    HStack(spacing: 12) {
                                        HStack {
                                            Image(systemName: "dollarsign.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.roseGold)
                                                .background(Color.white.clipShape(Circle()))
                                                .padding(6)
                                            
                                            Spacer()
                                            
                                            Text("\(playerViewModel.currentPlayer.money)")
                                                .font(.title2)
                                                .padding(.trailing, 12)
                                        }
                                        .frame(width: geometry.size.width*0.45, height: 42)
                                        .background {
                                            Capsule()
                                                .strokeBorder(Color.roseGold, lineWidth: 2.5)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "star.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.roseGold)
                                                .background(Color.white.clipShape(Circle()))
                                                .padding(6)
                                            
                                            Spacer()
                                            
                                            Text("\(playerViewModel.currentPlayer.star)")
                                                .font(.title2)
                                                .padding(.trailing, 12)
                                        }
                                        .frame(width: geometry.size.width*0.25, height: 42)
                                        .background {
                                            Capsule()
                                                .strokeBorder(Color.roseGold, lineWidth: 2.5)
                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            withAnimation {
                                                isShowSettings = true
                                            }
                                        } label: {
                                            Image(systemName: "gearshape.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32, height: 32)
                                                .foregroundColor(.roseGold)
                                        }
                                    }
                                    
                                    TabView(selection: $selectTab) {
                                        ForEach(TabType.allCases, id: \.self) { tabType in
                                            switch tabType {
                                            case .leaderBoard:
                                                LeaderBoardView(playerViewModel: playerViewModel, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage)
                                            case .game:
                                                GameLobbyView(playerViewModel: playerViewModel, gameViewModel: gameViewModel, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage)
                                            case .profile:
                                                ProfileView(authViewModel: authViewModel, playerViewModel: playerViewModel, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage, geometry: geometry)
                                            }
                                        }
                                    }
                                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                    
                                    HStack(spacing: 0) {
                                        ForEach(TabType.allCases, id: \.self) { tabType in
                                            Text(Image(systemName: "\(tabType.systemName)\(selectTab == tabType ? ".fill" : "")"))
                                                .font(selectTab == tabType ? .title.bold() : .title2)
                                                .foregroundColor(selectTab == tabType ? .white : .roseGold)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 48)
                                                .background {
                                                    Rectangle()
                                                        .foregroundColor(selectTab == tabType ? .roseGold : .backgroundColor)
                                                        .border(width: tabType == .game ? 1 : 0, edges: [.leading, .trailing], color: .roseGold)
                                                }
                                                .onTapGesture {
                                                    withAnimation {
                                                        selectTab = tabType
                                                    }
                                                }
                                        }
                                    }
                                    .cornerRadius(5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.roseGold, lineWidth: 2.5)
                                    }
                                }
                            case .waiting, .matching:
                                PrepareGameView(playerViewModel: playerViewModel, gameViewModel: gameViewModel, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage)
                            case .playing, .end:
                                GameView(playerViewModel: playerViewModel, gameViewModel: gameViewModel, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage)
                                    .onChange(of: gameViewModel.game.gameState) { gameState in
                                        if gameState == .end {
                                            appState = .loading
                                            if gameViewModel.game.gameType == .rank {
                                                playerViewModel.updateGameDataForRank(isWin: gameViewModel.game.winner == playerViewModel.currentPlayer.id) { result in
                                                    switch result {
                                                    case .success():
                                                        appState = .endGame
                                                    case .failure(let error):
                                                        alertTitle = "ERROR"
                                                        alertMessage = error.localizedDescription
                                                        appState = .alert
                                                    }
                                                }
                                            } else {
                                                playerViewModel.updateGameDataForCasual(isWin: gameViewModel.game.winner == playerViewModel.currentPlayer.id) { result in
                                                    switch result {
                                                    case .success():
                                                        appState = .endGame
                                                    case .failure(let error):
                                                        alertTitle = "ERROR"
                                                        alertMessage = error.localizedDescription
                                                        appState = .alert
                                                    }
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                        .foregroundColor(.white)
                        .padding([.bottom, .horizontal])
                        .background(Color.backgroundColor)
                        .overlay {
                            if isShowSettings {
                                SettingView(authViewModel: authViewModel, playerViewModel: playerViewModel, gameViewModel: gameViewModel, isShowSettings: $isShowSettings, hadTouchedScreen: $hadTouchedScreen, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage)
                            }
                        }
                    } else {
                        StarterView(authViewModel: authViewModel, playerViewModel: playerViewModel, hadTouchedScreen: $hadTouchedScreen, geometry: geometry)
                    }
                } else {
                    SignInContentView(authViewModel: authViewModel, playerViewModel: playerViewModel, hadTouchedScreen: $hadTouchedScreen, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage)
                }
                
                FullScreenCoverView(authViewModel: authViewModel, playerViewModel: playerViewModel, gameViewModel: gameViewModel, appState: $appState, alertTitle: $alertTitle, alertMessage: $alertMessage, geometry: geometry)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
