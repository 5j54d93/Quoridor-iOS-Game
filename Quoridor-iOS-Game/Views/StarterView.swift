//
//  StarterView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/10.
//

import SwiftUI

struct StarterView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var hadTouchedScreen: Bool
    
    @State private var opacity: Double = 0
    
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Text("Quoridor")
                .font(.largeTitle.bold())
            
            Spacer()
                .frame(height: geometry.size.height*0.33)
            
            Image("RoundAppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width*0.4, height: geometry.size.width*0.4)
            
            Spacer()
                .frame(height: geometry.size.height*0.1)
            
            Text("Player : \(authViewModel.currentUser?.displayName ?? "")")
                .font(.title2.bold())
            
            Divider()
                .frame(width: geometry.size.width*0.45, height: 1)
                .overlay(Color.white.opacity(0.45))
            
            Text("Touch screen to start")
                .foregroundColor(.lightBrown)
                .opacity(opacity)
                .onAppear {
                    opacity = 1
                }
                .animation(.easeIn(duration: 1).repeatForever(autoreverses: true), value: opacity)
            
            Spacer()
            
            HStack {
                Spacer()
                    .frame(width: geometry.size.width*0.15)
                
                Text("©2022 Ricky Chuang")
                
                Spacer()
                
                Text("v1.0.0")
                
                Spacer()
                    .frame(width: geometry.size.width*0.15)
            }
            .font(.caption2)
        }
        .foregroundColor(.white)
        .background(Color.darkBrown)
        .onTapGesture {
            if let currentPlayer = authViewModel.currentUser {
                playerViewModel.listenToPlayerDataChange(id: currentPlayer.uid)
            }
            withAnimation {
                hadTouchedScreen = true
            }
        }
    }
}
