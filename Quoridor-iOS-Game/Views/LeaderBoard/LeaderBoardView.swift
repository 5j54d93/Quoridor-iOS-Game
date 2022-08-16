//
//  LeaderBoardView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/7.
//

import SwiftUI

struct LeaderBoardView: View {
    
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    enum LeaderBoardType: CaseIterable {
        case star, winRate, money
        
        var description: String {
            switch self {
            case .star: return "Star"
            case .winRate: return "Win Rate"
            case .money: return "Money"
            }
        }
        var variableName: String {
            switch self {
            case .star: return "star"
            case .winRate: return "winRate"
            case .money: return "money"
            }
        }
    }
    
    @State private var selectLeaderBoardType: LeaderBoardType = .star
    @State private var searchText = ""
    @State private var myIndex = 1
    @State private var selectPlayer = Player(email: "loading", name: "loading", zodiacSign: .notSet, money: 2000, star: 0, maxStar: 0, birthYear: Calendar.current.component(.year, from: Date()) - 18, played: 0, win: 0, winRate: 0, haveGottenReward: false, joined: Date.now)
    @State private var isShowPlayer = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(LeaderBoardType.allCases, id: \.self) { leaderBoardType in
                        Text(LocalizedStringKey(leaderBoardType.description))
                            .font(selectLeaderBoardType == leaderBoardType ?  .title2.bold() : .title2)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background {
                                Rectangle()
                                    .foregroundColor(selectLeaderBoardType == leaderBoardType ? .roseGold : .earthyGold)
                                    .border(width: leaderBoardType == .winRate ? 1 : 0, edges: [.leading, .trailing], color: .backgroundColor)
                            }
                            .onTapGesture {
                                selectLeaderBoardType = leaderBoardType
                                fetchPlayers(scrollView: scrollView)
                            }
                    }
                }
                .cornerRadius(5)
                
                if playerViewModel.sortedPlayers == [] {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        ProgressView()
                            .scaleEffect(3)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        
                        Text("Loading...")
                            .font(.title3)
                            .padding(.top, 15)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .onAppear {
                        fetchPlayers(scrollView: scrollView)
                    }
                } else {
                    List {
                        ForEach(Array(playerViewModel.sortedPlayers.enumerated()), id: \.element) { index, player in
                            HStack(spacing: 15) {
                                Text("\(index+1)")
                                
                                AsyncImage(url: player.avatar) { image in
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
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                
                                Text(player.name)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                switch selectLeaderBoardType {
                                case .star:
                                    HStack(spacing: 5) {
                                        Text("\(player.star) ")
                                        
                                        Text(Image(systemName: "star.fill"))
                                            .foregroundColor(.lightBrown)
                                    }
                                case .winRate:
                                    Text("\(player.winRate, specifier: "%.1f") %")
                                case .money:
                                    Text("$ \(player.money)")
                                }
                            }
                            .listRowSeparator(.hidden)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .id(index+1)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(Color.roseGold, lineWidth: 2.5)
                                    .background {
                                        if index + 1 == myIndex {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundColor(.roseGold)
                                        }
                                    }
                            }
                            .onTapGesture {
                                selectPlayer = player
                                isShowPlayer = true
                            }
                        }
                    }
                    .listStyle(.inset)
                    .padding(.top, 10)
                    .padding(.horizontal, -25)
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                        UIRefreshControl.appearance().tintColor = UIColor.white
                        Array(playerViewModel.sortedPlayers.enumerated()).forEach { index, player in
                            if player.id == playerViewModel.currentPlayer.id {
                                myIndex = index + 1
                                withAnimation {
                                    scrollView.scrollTo(myIndex)
                                }
                            }
                        }
                    }
                    .refreshable {
                        fetchPlayers(scrollView: scrollView)
                    }
                }
            }
        }
        .padding(.vertical)
        .sheet(isPresented: $isShowPlayer) {
            PlayerSnapshotView(player: $selectPlayer, isShowPlayer: $isShowPlayer)
        }
    }
    
    func fetchPlayers(scrollView: ScrollViewProxy) {
        playerViewModel.fetchPlayers(sortType: selectLeaderBoardType.variableName) { result in
            switch result {
            case .success():
                Array(playerViewModel.sortedPlayers.enumerated()).forEach { index, player in
                    if player.id == playerViewModel.currentPlayer.id {
                        myIndex = index + 1
                        withAnimation {
                            scrollView.scrollTo(myIndex)
                        }
                    }
                }
            case .failure(let error):
                alertTitle = "ERROR"
                alertMessage = error.localizedDescription
                appState = .alert
            }
        }
    }
}
