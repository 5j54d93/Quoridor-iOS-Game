//
//  PlayerViewModel.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/6/30.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class PlayerViewModel: ObservableObject {
    
    @Published var currentPlayer = Player(email: "loading", name: "loading", zodiacSign: .notSet, money: 2000, star: 0, maxStar: 0, birthYear: Calendar.current.component(.year, from: Date()) - 18, played: 0, win: 0, winRate: 0, haveGottenReward: false, joined: Date.now)
    @Published var certainPlayer = Player(email: "loading", name: "loading", zodiacSign: .notSet, money: 2000, star: 0, maxStar: 0, birthYear: Calendar.current.component(.year, from: Date()) - 18, played: 0, win: 0, winRate: 0, haveGottenReward: false, joined: Date.now)
    @Published var sortedPlayers: [Player] = []
    
    let db = Firestore.firestore()
    
    func listenToPlayerDataChange(id: String) {
        db.collection("players").document(id).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            guard (try? snapshot.data(as: Player.self)) != nil else { return }
            guard let currentPlayer = try? snapshot.data(as: Player.self) else { return }
            self.currentPlayer = currentPlayer
        }
    }
    
    func isNewPlayer(email: String, completion: @escaping (Bool) -> Void) {
        db.collection("players").whereField("email", isEqualTo: email).getDocuments() { querySnapshot, err in
            guard let querySnapshot = querySnapshot else {
                completion(true)
                return
            }
            completion(querySnapshot.documents.isEmpty)
        }
    }
    
    func addPlayer(id: String, email: String?, name: String?, avatar: URL?, completion: @escaping (Result<Void, Error>) -> Void) {
        let data = Player(id: id, email: email ?? "not set", name: name ?? "not set", avatar: avatar ?? URL(string:  "https://firebasestorage.googleapis.com/v0/b/quoridor-ios-game.appspot.com/o/default.png?alt=media&token=d56342e8-76c0-4083-9a99-8c3f96d238b6"), zodiacSign: .notSet, money: 2000, star: 0, maxStar: 0, birthYear: Calendar.current.component(.year, from: Date()) - 18, played: 0, win: 0, winRate: 0, haveGottenReward: false, joined: Date.now)
        
        do {
            try db.collection("players").document(id).setData(from: data)
        } catch {
            completion(.failure(error))
        }
    }
    
    func updatePlayer(name: String, email: String, zodiacSign: Player.zodiacSignType, birthYear: Int, avatar: URL?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = currentPlayer.id else { return }
        let documentReference = db.collection("players").document(id)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var player = try? document.data(as: Player.self) else { return }
            player.name = name
            player.email = email
            player.zodiacSign = zodiacSign
            player.birthYear = birthYear
            if let avatar = avatar {
                player.avatar = avatar
            }
            do {
                try documentReference.setData(from: player)
            } catch {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    func uploadAvatar(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let id = currentPlayer.id else { return }
        let fileReference = Storage.storage().reference().child(id + ".jpg")
        if let data = image.jpegData(compressionQuality: 0.9) {
            fileReference.putData(data, metadata: nil) { result in
                switch result {
                case .success(_):
                    fileReference.downloadURL(completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteAvatar(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = currentPlayer.id else { return }
        let fileReference = Storage.storage().reference().child(id + ".jpg")
        fileReference.delete { error in
            guard error == nil else {
                if let error = error {
                    let error = error as NSError
                    if error.code != StorageErrorCode.objectNotFound.rawValue {
                        completion(.failure(error))
                    }
                }
                return
            }
            completion(.success(()))
        }
    }
    
    func deleteUser(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = currentPlayer.id else { return }
        let documentReference = db.collection("players").document(id)
        documentReference.delete()
        completion(.success(()))
    }
    
    func getReward(haveGottenReward: Bool, completion: @escaping (Result<Int, Error>) -> Void) {
        var reward = 0
        guard let id = currentPlayer.id else { return }
        let documentReference = db.collection("players").document(id)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var player = try? document.data(as: Player.self) else { return }
            player.haveGottenReward = haveGottenReward
            if haveGottenReward {
                reward = (1...200).randomElement()!
                player.money += reward
            }
            do {
                try documentReference.setData(from: player)
            } catch {
                completion(.failure(error))
            }
            completion(.success((reward)))
        }
    }
    
    func get200(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = currentPlayer.id else { return }
        let documentReference = db.collection("players").document(id)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var player = try? document.data(as: Player.self) else { return }
            player.money += 200
            player.lastAdPlayed = Date()
            do {
                try documentReference.setData(from: player)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func pay200(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let documentReference = db.collection("players").document(id)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var player = try? document.data(as: Player.self) else { return }
            player.money -= 200
            do {
                try documentReference.setData(from: player)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateGameDataForRank(isWin: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = currentPlayer.id else { return }
        let documentReference = db.collection("players").document(id)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var player = try? document.data(as: Player.self) else { return }
            if isWin {
                player.money += 400
                player.played += 1
                player.star += 1
                if player.star > player.maxStar {
                    player.maxStar = player.star
                }
                player.win += 1
                player.winRate = Double(player.win) / Double(player.played) * 100
            } else {
                player.played += 1
                if player.star > 0 {
                    player.star -= 1
                }
                player.winRate = Double(player.win) / Double(player.played) * 100
            }
            do {
                try documentReference.setData(from: player)
            } catch {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    func updateGameDataForCasual(isWin: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = currentPlayer.id else { return }
        let documentReference = db.collection("players").document(id)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var player = try? document.data(as: Player.self) else { return }
            if isWin {
                player.played += 1
                player.win += 1
                player.winRate = Double(player.win) / Double(player.played) * 100
            } else {
                player.played += 1
                player.winRate = Double(player.win) / Double(player.played) * 100
            }
            do {
                try documentReference.setData(from: player)
            } catch {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    func fetchPlayers(sortType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("players").order(by: sortType, descending: true).getDocuments { snapshot, error in
            guard let error = error else {
                guard let snapshot = snapshot else { return }
                let players = snapshot.documents.compactMap { snapshot in
                    try? snapshot.data(as: Player.self)
                }
                self.sortedPlayers = players
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }
    
    func fetchCertainPlayer(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let documentReference = db.collection("players").document(id)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, let player = try? document.data(as: Player.self) else { return }
                self.certainPlayer = player
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }
}
