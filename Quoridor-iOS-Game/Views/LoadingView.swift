//
//  LoadingView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/23.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var isLoading: Bool
    @Binding var errorMessage: String
    @Binding var isErrorOccured: Bool
    
    let geometry: GeometryProxy
    
    var body: some View {
        if isLoading {
            Color.white
                .ignoresSafeArea()
                .opacity(0.7)
            
            if isErrorOccured {
                VStack(spacing: 20) {
                    Text(errorMessage)
                        .foregroundColor(.roseGold)
                    
                    Button {
                        isLoading = false
                        isErrorOccured = false
                    } label: {
                        Text("OK")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                                    .foregroundColor(.roseGold)
                            }
                    }
                }
                .padding(20)
                .frame(width: geometry.size.width*0.8)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                }
            } else {
                ProgressView()
                    .scaleEffect(3)
                    .progressViewStyle(CircularProgressViewStyle(tint: .roseGold))
            }
        }
    }
}
