//
//  AuthViewModel.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/6/28.
//

import Foundation
import Firebase
import FirebaseAuth
import FacebookLogin
import GoogleSignIn
import SwiftUI

class AuthViewModel: ObservableObject {
    
    @Published var currentUser = Auth.auth().currentUser
    @Published var providers: [String] = []
    
    let twitterProvider = OAuthProvider(providerID: "twitter.com")
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.currentUser = user
            guard let currentUser = user else { return }
            self.providers = []
            for providerData in currentUser.providerData {
                self.providers.append(providerData.providerID)
            }
        }
    }
    
    func signInWithFacebook(completion: @escaping (String) -> Void) {
        LoginManager().logIn(permissions: [.email, .publicProfile]) { result in
            switch result {
            case .success(granted: _, declined: _, token: let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token!.tokenString)
                Auth.auth().signIn(with: credential) { authResult, error in
                    guard let error = error else {
                        completion("success")
                        return
                    }
                    completion(error.localizedDescription)
                }
            case .failed(let error):
                completion(error.localizedDescription)
            case .cancelled:
                completion("You've canceled login with Facebook.")
            }
        }
    }
    
    func signInWithGoogle(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { user, error in
            guard let error = error else {
                guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                Auth.auth().signIn(with: credential) { authResult, error in
                    guard let error = error else {
                        completion(.success(()))
                        return
                    }
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func signInWithTwitter(completion: @escaping (Result<Void, Error>) -> Void) {
        twitterProvider.getCredentialWith(nil) { credential, error in
            guard let error = error else {
                guard let credential = credential else { return }
                Auth.auth().signIn(with: credential) { authResult, error in
                    guard let error = error else {
                        completion(.success(()))
                        return
                    }
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func signUpWithEmail(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard authResult?.user != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(()))
        }
    }
    
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard authResult?.user != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(()))
        }
    }
    
    func sendPasswordResetEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard let error = error else {
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }
    
    func updateUser(name: String, email: String, avatar: URL?, completion: @escaping (Result<Void, Error>) -> Void) {
        let changeRequest = currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        if let avatar = avatar {
            changeRequest?.photoURL = avatar
        }
        changeRequest?.commitChanges(completion: { error in
            guard let error = error else { return }
            completion(.failure(error))
        })
        if providers.contains("password") {
            currentUser?.updateEmail(to: email) { error in
                guard let error = error else { return }
                completion(.failure(error))
            }
        }
        completion(.success(()))
    }
    
    func updatePassword(password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        currentUser?.updatePassword(to: password) { error in
            guard let error = error else {
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }
    
    func deleteUser(completion: @escaping (Result<Void, Error>) -> Void) {
        currentUser?.delete { error in
            guard let error = error else {
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func connectToEmail(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        currentUser?.link(with: credential) { authResult, error in
            guard let error = error else {
                withAnimation {
                    self.providers.append("password")
                }
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }
    
    func connectToFacebook(completion: @escaping (Result<Void, Error>) -> Void) {
        LoginManager().logIn(permissions: [.email, .publicProfile]) { result in
            switch result {
            case .success(granted: _, declined: _, token: let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token!.tokenString)
                self.currentUser?.link(with: credential) { authResult, error in
                    guard let error = error else {
                        withAnimation {
                            self.providers.append("facebook.com")
                        }
                        completion(.success(()))
                        return
                    }
                    completion(.failure(error))
                }
            case .failed(let error):
                completion(.failure(error))
            case .cancelled:
                break
            }
        }
    }
    
    func connectToGoogle(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { user, error in
            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            self.currentUser?.link(with: credential) { authResult, error in
                guard let error = error else {
                    withAnimation {
                        self.providers.append("google.com")
                    }
                    completion(.success(()))
                    return
                }
                completion(.failure(error))
            }
        }
    }
    
    func connectToTwitter(completion: @escaping (Result<Void, Error>) -> Void) {
        twitterProvider.getCredentialWith(nil) { credential, error in
            guard let error = error else {
                guard let credential = credential else { return }
                self.currentUser?.link(with: credential) { authResult, error in
                    guard let error = error else {
                        withAnimation {
                            self.providers.append("twitter.com")
                        }
                        completion(.success(()))
                        return
                    }
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func disconnect(provider: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.currentUser?.unlink(fromProvider: provider) { user, error in
            guard let error = error else {
                withAnimation {
                    guard let currentUser = user else { return }
                    self.providers = []
                    for providerData in currentUser.providerData {
                        self.providers.append(providerData.providerID)
                    }
                }
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }
}
