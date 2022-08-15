//
//  LoadingView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/15.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var isLoading: Bool
    @Binding var isAlert: Bool
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    let geometry: GeometryProxy
    
    var body: some View {
        if isLoading {
            Color.white
                .opacity(0.7)
                .ignoresSafeArea()
            
            if isAlert {
                VStack(spacing: 20) {
                    Text(LocalizedStringKey(alertTitle))
                        .font(.title.bold())
                        .foregroundColor(.roseGold)
                    
                    Text(LocalizedStringKey(alertMessage))
                        .foregroundColor(.roseGold)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        isLoading = false
                        isAlert = false
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
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(3)
                        .progressViewStyle(CircularProgressViewStyle(tint: .roseGold))
                    
                    Text("Updating...")
                        .font(.title3)
                        .padding(.top, 15)
                        .foregroundColor(.roseGold)
                }
            }
        }
    }
}
