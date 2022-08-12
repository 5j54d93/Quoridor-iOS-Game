//
//  SignInWithEmailView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/6/28.
//

import SwiftUI

struct SignInWithEmailView: View {
    
    @AppStorage("currentPassword") var currentPassword = ""
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var playerType: SignInContentView.PlayerType
    @Binding var isSignInWithEmail: Bool
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    @State private var email = ""
    @State private var password = ""
    @State private var isPorgotPassword = false
    
    enum Field: Hashable { case email, password }
    
    @FocusState private var focusedField: Field?
    
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Spacer()
            
            if !isPorgotPassword {
                Text(LocalizedStringKey(playerType.description.uppercased() + " WITH EMAIL"))
                    .font(.title3.bold())
                    .padding(.bottom, 5)
            } else {
                Text("FORGOT PASSWORD")
                    .font(.title3.bold())
                    .padding(.bottom, 5)
            }
            
            TextField("Email", text: $email)
                .prompt(when: email.isEmpty) {
                    Text("Email")
                        .foregroundColor(.white.opacity(0.65))
                }
                .padding(15)
                .border(.white, width: 2)
                .frame(width: geometry.size.width*2/3, height: 52)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .email)
                .onSubmit {
                    if !isPorgotPassword {
                        focusedField = .password
                    } else {
                        resetPassword()
                    }
                }
            
            if !isPorgotPassword {
                SecureField("Password", text: $password)
                    .prompt(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.white.opacity(0.65))
                    }
                    .padding(15)
                    .border(.white, width: 2)
                    .frame(width: geometry.size.width*2/3, height: 52)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        signIn()
                    }
            }
            
            Button {
                if !isPorgotPassword {
                    signIn()
                } else {
                    resetPassword()
                }
            } label: {
                Capsule()
                    .frame(width: geometry.size.width*4/7, height: 50)
                    .foregroundColor(.roseGold)
                    .overlay {
                        if !isPorgotPassword {
                            Text(LocalizedStringKey(playerType.description.uppercased()))
                                .font(.title3.bold())
                        } else {
                            Text("Reset password")
                                .font(.title3.bold())
                        }
                    }
            }
            .disabled(
                !isPorgotPassword
                ? email.isEmpty || password.isEmpty
                : email.isEmpty
            )
            .padding(.top, 5)
            
            Spacer()
            
            if playerType == .returning {
                Button {
                    withAnimation {
                        isPorgotPassword.toggle()
                    }
                } label: {
                    Text(isPorgotPassword ? "Back" : "Forgot your password ?")
                        .foregroundColor(.lightBrown)
                }
            }
            
            Spacer()
            
            Button {
                isSignInWithEmail = false
            } label: {
                Text(Image(systemName: "xmark.circle"))
                    .font(.largeTitle)
                    .foregroundColor(.roseGold)
                    .background {
                        Circle()
                            .foregroundColor(.lightBrown)
                    }
            }
            .padding(.bottom)
        }
        .foregroundColor(.white)
    }
    
    func signIn() {
        appState = .loading
        playerViewModel.isNewPlayer(email: email.lowercased()) { result in
            switch result {
            case true:
                authViewModel.signUpWithEmail(email: email, password: password) { result in
                    switch result {
                    case .success():
                        if let user = authViewModel.currentUser {
                            currentPassword = password
                            playerViewModel.addPlayer(id: user.uid, email: user.email, name: nil, avatar: nil) { result in
                                if case .failure(let error) = result {
                                    alertTitle = "ERROR"
                                    alertMessage = error.localizedDescription
                                    appState = .alert
                                }
                            }
                        }
                    case .failure(let error):
                        alertTitle = "ERROR"
                        alertMessage = error.localizedDescription
                        appState = .alert
                    }
                }
            case false:
                authViewModel.signInWithEmail(email: email, password: password) { result in
                    switch result {
                    case .success():
                        appState = .null
                        currentPassword = password
                    case .failure(let error):
                        alertTitle = "ERROR"
                        alertMessage = error.localizedDescription
                        appState = .alert
                    }
                }
            }
        }
    }
    
    func resetPassword() {
        appState = .loading
        authViewModel.sendPasswordResetEmail(email: email) { result in
            switch result {
            case .success():
                alertTitle = "Check your Email"
                alertMessage = "We've sent a email to \(email). Don't forget to reset your password via link"
                appState = .alert
            case .failure(let error):
                alertTitle = "ERROR"
                alertMessage = error.localizedDescription
                appState = .alert
            }
        }
    }
}
