//
//  ChoosePlayerTypeView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/6/28.
//

import SwiftUI

struct ChoosePlayerTypeView: View {
    
    @Binding var playerType: SignInContentView.PlayerType
    
    let geometry: GeometryProxy
    
    var body: some View {
        Spacer()
        
        Button {
            withAnimation {
                playerType = .returning
            }
        } label: {
            Text("RETURING PLAYER")
                .font(.title3.bold())
                .foregroundColor(.white)
                .frame(width: geometry.size.width*2/3, height: 52)
                .background {
                    Capsule()
                        .foregroundColor(.roseGold)
                }
        }
        
        Button {
            withAnimation {
                playerType = .new
            }
        } label: {
            Text("NEW PLAYER")
                .font(.title3.bold())
                .foregroundColor(.lightBrown)
                .frame(width: geometry.size.width*2/3, height: 52)
                .background {
                    Capsule()
                        .stroke(Color.lightBrown, lineWidth: 2.5)
                }
        }
        
        Spacer()
        
        Text("©2022 Ricky Chuang")
            .foregroundColor(.white)
            .font(.caption2)
            .padding(.bottom, 10)
    }
}
