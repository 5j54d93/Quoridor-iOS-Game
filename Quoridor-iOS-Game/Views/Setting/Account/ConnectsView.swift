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
    
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
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
                                    appState = .loading
                                    if authViewModel.providers.contains(connectMethod.provider) {
                                        if authViewModel.providers.count == 1 {
                                            alertTitle = "ERROR"
                                            alertMessage = "You must connect to at least one account or you can't login to Quoridor."
                                            appState = .alert
                                        } else {
                                            authViewModel.disconnect(provider: connectMethod.provider) { result in
                                                switch result {
                                                case .success():
                                                    appState = .null
                                                case .failure(let error):
                                                    alertTitle = "ERROR"
                                                    alertMessage = error.localizedDescription
                                                    appState = .alert
                                                }
                                            }
                                        }
                                    } else {
                                        switch connectMethod {
                                        case .Facebook:
                                            authViewModel.connectToFacebook { result in
                                                switch result {
                                                case .success():
                                                    appState = .null
                                                case .failure(let error):
                                                    alertTitle = "ERROR"
                                                    alertMessage = error.localizedDescription
                                                    appState = .alert
                                                }
                                            }
                                        case .Google:
                                            authViewModel.connectToGoogle { result in
                                                switch result {
                                                case .success():
                                                    appState = .null
                                                case .failure(let error):
                                                    alertTitle = "ERROR"
                                                    alertMessage = error.localizedDescription
                                                    appState = .alert
                                                }
                                            }
                                        case .Twitter:
                                            authViewModel.connectToTwitter { result in
                                                switch result {
                                                case .success():
                                                    appState = .null
                                                case .failure(let error):
                                                    alertTitle = "ERROR"
                                                    alertMessage = error.localizedDescription
                                                    appState = .alert
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
        }
        .navigationBarHidden(true)
        .foregroundColor(.white)
        .background(Color.backgroundColor)
    }
    
    func handleEmailConnection() {
        appState = .loading
        if authViewModel.providers.contains("password") {
            if authViewModel.providers.count == 1 {
                alertTitle = "ERROR"
                alertMessage = "You must connect to at least one account or you can't login to Quoridor."
                appState = .alert
            } else {
                authViewModel.disconnect(provider: "password") { result in
                    switch result {
                    case .success():
                        appState = .null
                    case .failure(let error):
                        alertTitle = "ERROR"
                        alertMessage = error.localizedDescription
                        appState = .alert
                    }
                }
            }
        } else {
            authViewModel.connectToEmail(email: email, password: password) { result in
                switch result {
                case .success():
                    playerViewModel.updatePlayer(name: playerViewModel.currentPlayer.name, email: email, zodiacSign: playerViewModel.currentPlayer.zodiacSign, birthYear: playerViewModel.currentPlayer.birthYear, avatar: nil) { result in
                        switch result {
                        case .success():
                            appState = .null
                        case .failure(let error):
                            alertTitle = "ERROR"
                            alertMessage = error.localizedDescription
                            appState = .alert
                        }
                    }
                case .failure(let error):
                    alertTitle = "ERROR"
                    alertMessage = error.localizedDescription
                    appState = .alert
                }
            }
        }
    }
}
