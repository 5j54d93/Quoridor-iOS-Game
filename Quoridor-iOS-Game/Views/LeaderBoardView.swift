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
                            playerViewModel.fetchPlayers(sortType: selectLeaderBoardType.variableName)
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
                    playerViewModel.fetchPlayers(sortType: selectLeaderBoardType.variableName)
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
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.roseGold, lineWidth: 2.5)
                        }
                    }
                }
                .listStyle(.inset)
                .padding(.top, 10)
                .padding(.horizontal, -25)
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                    UIRefreshControl.appearance().tintColor = UIColor.white
                }
                .refreshable {
                    playerViewModel.fetchPlayers(sortType: selectLeaderBoardType.variableName)
                }
            }
        }
        .padding(.vertical)
    }
}
