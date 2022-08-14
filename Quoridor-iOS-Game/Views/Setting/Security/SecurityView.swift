//
//  SecurityView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/4.
//

import SwiftUI

struct SecurityView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(Image(systemName: "chevron.backward"))
                        .font(.title3.bold())
                }
                
                Spacer()
            }
            .overlay {
                Text("Security")
                    .font(.title2.bold())
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 1)
                .overlay(Color.earthyGold)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("Login security")
                            .font(.title2.bold())
                        
                        NavigationLink {
                            ChangePasswordView(authViewModel: authViewModel)
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "key")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                
                                Text("Password")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text(Image(systemName: "chevron.forward"))
                                    .foregroundColor(.earthyGold)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(Color.earthyGold)
                }
            }
        }
        .navigationBarHidden(true)
        .foregroundColor(.white)
        .background(Color.backgroundColor)
    }
}
