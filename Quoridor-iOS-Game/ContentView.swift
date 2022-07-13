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
    
    @State private var selectTab: TabType = .game
    @State private var isShowSettings = false
    
    var body: some View {
        if let currentUser = authViewModel.currentUser {
            GeometryReader { geometry in
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
                        .frame(width: geometry.size.width*0.45, height: 40)
                        .background {
                            Capsule()
                                .stroke(Color.roseGold, lineWidth: 2.5)
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
                        .frame(width: geometry.size.width*0.25, height: 40)
                        .background {
                            Capsule()
                                .stroke(Color.roseGold, lineWidth: 2.5)
                        }
                        
                        Spacer()
                        
                        Button {
                            isShowSettings = true
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
                                Text("Leader Board")
                            case .game:
                                Text("Game")
                            case .profile:
                                ProfileView(authViewModel: authViewModel, playerViewModel: playerViewModel, geometry: geometry)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    HStack(spacing: 0) {
                        ForEach(TabType.allCases, id: \.self) { tabType in
                            if tabType == .game {
                                Divider()
                                    .frame(width: 2.5)
                                    .overlay(Color.roseGold)
                            }
                            
                            Text(Image(systemName: "\(tabType.systemName)\(selectTab == tabType ? ".fill" : "")"))
                                .font(selectTab == tabType ? .title.bold() : .title2)
                                .foregroundColor(selectTab == tabType ? .white : .roseGold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background {
                                    Rectangle()
                                        .foregroundColor(selectTab == tabType ? .roseGold : .backgroundColor)
                                }
                                .onTapGesture {
                                    withAnimation {
                                        selectTab = tabType
                                    }
                                }
                            
                            if tabType == .game {
                                Divider()
                                    .frame(width: 2.5)
                                    .overlay(Color.roseGold)
                            }
                        }
                    }
                    .frame(height: 48)
                    .cornerRadius(5)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.roseGold, lineWidth: 2.5)
                    }
                }
                .padding(.bottom)
                .padding(.horizontal)
                .foregroundColor(.white)
                .background(Color.backgroundColor)
            }
            .overlay {
                if isShowSettings {
                    SettingView(authViewModel: authViewModel, playerViewModel: playerViewModel, isShowSettings: $isShowSettings)
                }
            }
            .onAppear {
                playerViewModel.listenToPlayerDataChange(id: currentUser.uid)
            }
        } else {
            SignInContentView(authViewModel: authViewModel, playerViewModel: playerViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
