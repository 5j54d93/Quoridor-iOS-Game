//
//  PlayerSnapshotView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/16.
//

import SwiftUI

struct PlayerSnapshotView: View {
    
    @Binding var player: Player
    @Binding var isShowPlayer: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 15) {
                HStack {
                    Button {
                        isShowPlayer = false
                    } label: {
                        Text(Image(systemName: "xmark"))
                            .font(.title3)
                            .opacity(0.85)
                    }
                    
                    Spacer()
                }
                .overlay {
                    Text("Player's Info")
                        .font(.title2.bold())
                }
                .padding(.bottom)
                
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
                .frame(width: geometry.size.width*0.25, height: geometry.size.width*0.25)
                .clipShape(Circle())
                
                Text(player.name)
                    .font(.title)
                
                HStack {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.roseGold)
                            .background(Color.white.clipShape(Circle()))
                        
                        VStack {
                            Text("Wealth")
                            
                            Text("\(player.money)")
                        }
                        .padding(.horizontal, 5)
                    }
                    .padding(8)
                    .frame(height: 48)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.middleBrown)
                    }
                    
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.roseGold)
                            .background(Color.white.clipShape(Circle()))
                        
                        VStack {
                            Text("Rank")
                            
                            Text("\(player.star)")
                        }
                        .padding(.horizontal, 6)
                    }
                    .padding(8)
                    .frame(height: 48)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.middleBrown)
                    }
                }
                
                HStack {
                    Group {
                        VStack(spacing: 5) {
                            Text("\(player.played)")
                                .font(.title2.bold())
                            
                            Text("Played")
                        }
                        
                        VStack(spacing: 5) {
                            Text("\(player.winRate, specifier: "%.1f") %")
                                .font(.title2.bold())
                            
                            Text("Win Rate")
                        }
                        
                        VStack(spacing: 5) {
                            Text("\(player.maxStar)")
                                .font(.title2.bold())
                            
                            Text("Max Star")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.roseGold, lineWidth: 2.5)
                }
                
                VStack {
                    HStack {
                        Text("About")
                            .font(.title3.bold())
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.roseGold)
                    
                    Group {
                        HStack {
                            Text("Age")
                                .bold()
                            
                            Spacer()
                            
                            Text("\(Calendar.current.component(.year, from: Date()) - player.birthYear)")
                        }
                        .padding(.top, 5)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(Color.earthyGold)
                            .padding(.vertical, 5)
                        
                        HStack {
                            Text("Zodiac Sign")
                                .bold()
                            
                            Spacer()
                            
                            Text(LocalizedStringKey(player.zodiacSign.description))
                        }
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(Color.earthyGold)
                            .padding(.vertical, 5)
                        
                        HStack {
                            Text("Joined")
                                .bold()
                            
                            Spacer()
                            
                            Text("\(player.joined.formatted(date: .abbreviated, time: .omitted))")
                        }
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.roseGold, lineWidth: 2.5)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
        }
    }
}
