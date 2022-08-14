//
//  SourceCodeView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/14.
//

import SwiftUI

struct SourceCodeView: View {
    
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
                Text("Source Code")
                    .font(.title2.bold())
            }
            .padding(.horizontal)
            
            SafariView(url: URL(string: "https://github.com/5j54d93/Quoridor-iOS-Game")!)
                .ignoresSafeArea(.all, edges: .bottom)
        }
        .navigationBarHidden(true)
        .foregroundColor(.white)
        .background(Color.backgroundColor)
    }
}
