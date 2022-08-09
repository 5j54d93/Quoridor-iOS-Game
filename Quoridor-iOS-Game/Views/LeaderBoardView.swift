//
//  LeaderBoardView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/7.
//

import SwiftUI

struct LeaderBoardView: View {
    
    @ObservedObject var playerViewModel: PlayerViewModel
    
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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(LeaderBoardType.allCases, id: \.self) { leaderBoardType in
                    if leaderBoardType == .winRate {
                        Divider()
                            .frame(height: 1.5)
                            .overlay(Color.roseGold)
                    }
                    
                    Button {
                        withAnimation {
                            selectLeaderBoardType = leaderBoardType
                            playerViewModel.fetchPlayers(sortType: selectLeaderBoardType.variableName)
                        }
                    } label: {
                        Text(LocalizedStringKey(leaderBoardType.description))
                            .font(.title2.bold())
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background {
                                Rectangle()
                                    .foregroundColor(selectLeaderBoardType == leaderBoardType ? .roseGold : .earthyGold)
                            }
                    }
                    
                    if leaderBoardType == .winRate {
                        Divider()
                            .frame(height: 1.5)
                            .overlay(Color.roseGold)
                    }
                }
            }
            .cornerRadius(5)
            
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
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.roseGold, lineWidth: 2.5)
                    }
                }
            }
            .listStyle(.inset)
            .padding(.horizontal, -25)
            .padding(.top, 10)
            .background(Color.clear)
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
                UIRefreshControl.appearance().tintColor = UIColor.white
            }
            .refreshable {
                playerViewModel.fetchPlayers(sortType: selectLeaderBoardType.variableName)
            }
        }
        .padding(.vertical)
        .onAppear {
            playerViewModel.fetchPlayers(sortType: selectLeaderBoardType.variableName)
        }
    }
}
