//
//  AboutView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/5.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                Text("About")
                    .font(.title2.bold())
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 1)
                .overlay(Color.earthyGold)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        NavigationLink {
                            SourceCodeView()
                        } label: {
                            HStack(spacing: 10) {
                                Text("Source code")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text(Image(systemName: "chevron.forward"))
                                    .foregroundColor(.earthyGold)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
            }
        }
        .navigationBarHidden(true)
        .foregroundColor(.white)
        .background(Color.backgroundColor)
    }
}
