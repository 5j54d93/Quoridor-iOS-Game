//
//  ConnectsView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/10.
//

import SwiftUI

struct ConnectsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    enum ConnectMethod: CaseIterable {
        case Facebook, Google, Twitter
        
        var description: String {
            switch self {
            case .Facebook: return "Facebook"
            case .Google: return "Google"
            case .Twitter: return "Twitter"
            }
        }
        var image: Image {
            switch self {
            case .Facebook: return Image("FacebookLogo")
            case .Google: return Image("GoogleLogo")
            case .Twitter: return Image("TwitterLogo")
            }
        }
        var provider: String {
            switch self {
            case .Facebook: return "facebook.com"
            case .Google: return "google.com"
            case .Twitter: return "twitter.com"
            }
        }
    }
    
    @State private var isExpandEmail = false
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showProgressView = false
    
    enum Field: Hashable { case email, password }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        GeometryReader { geometry in
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
                    Text("Connects")
                        .font(.title2.bold())
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.earthyGold)
                
                ScrollView {
                    VStack(spacing: 25) {
                        Text("You can sign in to Quoridor using accounts that you have connected.")
                            .frame(alignment: .leading)
                        
                        Button {
                            withAnimation {
                                isExpandEmail.toggle()
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "envelope.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                
                                Text("Email")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text(Image(systemName: "chevron.forward"))
                                    .foregroundColor(.lightBrown)
                                    .rotationEffect(isExpandEmail ? Angle(degrees: 90) : Angle(degrees: 0))
                            }
                        }
                        
                        if isExpandEmail {
                            VStack {
                                HStack {
                                    Text("Email")
                                        .font(.title3)
                                        .frame(width: geometry.size.width/3, alignment: .leading)
                                    
                                    TextField("Email", text: $email)
                                        .font(.title3)
                                        .onSubmit {
                                            focusedField = .password
                                        }
                                        .onAppear {
                                            email = authViewModel.currentUser?.email ?? ""
                                        }
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color.earthyGold)
                                
                                HStack {
                                    Text("Password")
                                        .font(.title3)
                                        .frame(width: geometry.size.width/3, alignment: .leading)
                                    
                                    SecureField("Password", text: $password)
                                        .prompt(when: password.isEmpty) {
                                            Text("password")
                                                .foregroundColor(.white.opacity(0.65))
                                        }
                                        .font(.title3)
                                        .focused($focusedField, equals: .password)
                                        .onSubmit {
                                            handleEmailConnection()
                                        }
                                }
                                .padding(.top, 5)
                                
                                Button {
                                    handleEmailConnection()
                                } label: {
                                    if authViewModel.providers.contains("password") {
                                        Text("disconnect")
                                            .font(.title2)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 12)
                                            .background {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .foregroundColor(.roseGold)
                                            }
                                    } else {
                                        Text("connect")
                                            .font(.title2)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(.lightBrown)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 12)
                                            .background {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.lightBrown, lineWidth: 1)
                                            }
                                    }
                                }
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.roseGold, lineWidth: 1.5)
                            }
                        }
                        
                        ForEach(ConnectMethod.allCases, id: \.self) { connectMethod in
                            HStack(spacing: 10) {
                                connectMethod.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                
                                Text(connectMethod.description)
                                    .font(.title2)
                                
                                Spacer()
                                
                                Button {
                                    showProgressView = true
                                    if authViewModel.providers.contains(connectMethod.provider) {
                                        if authViewModel.providers.count == 1 {
                                            alertMessage = "You must connect to at least one account or you can't login to Quoridor."
                                            showAlert = true
                                        } else {
                                            authViewModel.disconnect(provider: connectMethod.provider) { result in
                                                switch result {
                                                case .success():
                                                    showProgressView = false
                                                case .failure(let error):
                                                    alertMessage = error.localizedDescription
                                                    showAlert = true
                                                }
                                            }
                                        }
                                    } else {
                                        switch connectMethod {
                                        case .Facebook:
                                            authViewModel.connectToFacebook { result in
                                                switch result {
                                                case .success():
                                                    showProgressView = false
                                                case .failure(let error):
                                                    alertMessage = error.localizedDescription
                                                    showAlert = true
                                                }
                                            }
                                        case .Google:
                                            authViewModel.connectToGoogle { result in
                                                switch result {
                                                case .success():
                                                    showProgressView = false
                                                case .failure(let error):
                                                    alertMessage = error.localizedDescription
                                                    showAlert = true
                                                }
                                            }
                                        case .Twitter:
                                            authViewModel.connectToTwitter { result in
                                                switch result {
                                                case .success():
                                                    showProgressView = false
                                                case .failure(let error):
                                                    alertMessage = error.localizedDescription
                                                    showAlert = true
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    if authViewModel.providers.contains(connectMethod.provider) {
                                        Text("disconnect")
                                            .font(.title2)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 12)
                                            .background {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .foregroundColor(.roseGold)
                                            }
                                    } else {
                                        Text("connect")
                                            .font(.title2)
                                            .foregroundColor(.lightBrown)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 12)
                                            .background {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.lightBrown, lineWidth: 1)
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                }
            }
            .overlay {
                if showProgressView {
                    Color.white
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity)
                        .opacity(0.7)
                    
                    if !showAlert {
                        ProgressView()
                            .scaleEffect(3)
                            .progressViewStyle(CircularProgressViewStyle(tint: .roseGold))
                    } else {
                        VStack(spacing: 20) {
                            Text(alertMessage)
                                .foregroundColor(.roseGold)
                            
                            Button {
                                showProgressView = false
                                showAlert = false
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
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .foregroundColor(.white)
        .background(Color.backgroundColor)
    }
    
    func handleEmailConnection() {
        showProgressView = true
        if authViewModel.providers.contains("password") {
            if authViewModel.providers.count == 1 {
                alertMessage = "You must connect to at least one account or you can't login to Quoridor."
                showAlert = true
            } else {
                authViewModel.disconnect(provider: "password") { result in
                    switch result {
                    case .success():
                        showProgressView = false
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }
        } else {
            authViewModel.connectToEmail(email: email, password: password) { result in
                switch result {
                case .success():
                    playerViewModel.updatePlayer(name: playerViewModel.currentPlayer.name, email: email, zodiacSign: playerViewModel.currentPlayer.zodiacSign, age: playerViewModel.currentPlayer.age, avatar: nil) { result in
                        switch result {
                        case .success():
                            showProgressView = false
                        case .failure(let error):
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}
