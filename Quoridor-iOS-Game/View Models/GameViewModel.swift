//
//  GameViewModel.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/16.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

class GameViewModel: ObservableObject {
    
    @AppStorage("soundEffectVolume") var soundEffectVolume = 0.5
    
    @Published var game = Game()
    
    var listener: ListenerRegistration?
    var buildWallPlayer: AVPlayer { AVPlayer.buildWallPlayer }
    var moveChessmanPlayer: AVPlayer { AVPlayer.moveChessmanPlayer }
    
    let db = Firestore.firestore()
    
    init() {
        setVolume(volume: Float(soundEffectVolume))
    }
    
    func listenToGameDataChange(id: String) {
        listener = db.collection("games").document(id).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            guard (try? snapshot.data(as: Game.self)) != nil else { return }
            guard let game = try? snapshot.data(as: Game.self) else { return }
            withAnimation {
                self.game = game
            }
        }
    }
    
    func createRoom(gameType: Game.GameType, player: Player, completion: @escaping (String) -> Void) {
        if gameType == .rank && player.money < 200 {
            completion("This room is for rank and your money is less than $200, we couldn't let you in.")
            return
        }
        var randomId = (0...99999).randomElement()!
        db.collection("games").getDocuments { snapshot, error in
            guard let error = error else {
                guard let snapshot = snapshot else { return }
                let games = snapshot.documents.compactMap { snapshot in
                    try? snapshot.data(as: Game.self)
                }
                while(games.contains(where: { $0.id == String(randomId) })) {
                    randomId = (0...99999).randomElement()!
                }
                return
            }
            completion(error.localizedDescription)
        }
        let data = Game(id: String(randomId), gameType: gameType, gameState: .waiting, roomOwner: player)
        
        do {
            try db.collection("games").document(String(randomId)).setData(from: data)
            listenToGameDataChange(id: String(randomId))
            completion("success")
        } catch {
            completion(error.localizedDescription)
        }
    }
    
    func exitRoom(player: Player, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
                if game.joinedPlayer == nil {
                    documentReference.delete()
                } else {
                    if game.roomOwner?.email == player.email {
                        game.roomOwner = game.joinedPlayer
                        game.joinedPlayer = nil
                    } else {
                        game.joinedPlayer = nil
                    }
                    do {
                        try documentReference.setData(from: game)
                    } catch {
                        completion(.failure(error))
                    }
                }
                self.game = Game()
                if self.listener != nil {
                    self.listener!.remove()
                }
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }
    
    func joinRoom(roomId: String, player: Player, completion: @escaping (String) -> Void) {
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else {
                    completion("wrong room id")
                    return
                }
                guard game.joinedPlayer == nil else {
                    completion("This room is full of players.")
                    return
                }
                if game.gameType == .rank && player.money < 200 {
                    completion("This room is for rank and your money is less than $200, we couldn't let you in.")
                    return
                }
                game.joinedPlayer = player
                game.gameState = .waiting
                do {
                    try documentReference.setData(from: game)
                    self.listenToGameDataChange(id: roomId)
                    completion("success")
                } catch {
                    completion(error.localizedDescription)
                }
                return
            }
            completion(error.localizedDescription)
        }
    }
    
    func toggleReadyToPlay(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
                game.isReadyToPlay.toggle()
                do {
                    try documentReference.setData(from: game)
                } catch {
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func startTheGame(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
                game.turn = [game.roomOwner, game.joinedPlayer].randomElement()!
                game.gameState = .playing
                do {
                    try documentReference.setData(from: game)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func changeGameStateToMatch(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
                game.gameState = .matching
                do {
                    try documentReference.setData(from: game)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func findMatchGame(completion: @escaping (String) -> Void) {
        guard let roomId = game.id else { return }
        db.collection("games").getDocuments { snapshot, error in
            guard let error = error else {
                guard let snapshot = snapshot else { return }
                let games = snapshot.documents.compactMap { snapshot in
                    try? snapshot.data(as: Game.self)
                }
                for game in games {
                    if game.id != roomId && game.gameType == self.game.gameType && game.gameState == .matching {
                        self.db.collection("games").document(roomId).delete()
                        guard let newRoomId = game.id else { return }
                        self.game = game
                        self.listenToGameDataChange(id: newRoomId)
                        completion("found")
                        break
                    }
                }
                completion("not found")
                return
            }
            completion(error.localizedDescription)
        }
    }
    
    func joinMatchedRoom(player: Player, completion: @escaping (String) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else {
                    completion("some error occured")
                    return
                }
                game.joinedPlayer = player
                game.turn = [game.roomOwner, game.joinedPlayer].randomElement()!
                game.gameState = .playing
                do {
                    try documentReference.setData(from: game)
                    completion("success")
                } catch {
                    completion(error.localizedDescription)
                }
                return
            }
            completion(error.localizedDescription)
        }
    }
    
    func cancelMatching(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
                game.gameState = .waiting
                do {
                    try documentReference.setData(from: game)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func buildWall(indexes: [Int], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
                game.wall += indexes
                if game.turn?.email == game.roomOwner?.email {
                    game.roomOwnerWall -= 1
                    game.turn = game.joinedPlayer
                } else {
                    game.joinedPlayerWall -= 1
                    game.turn = game.roomOwner
                }
                do {
                    try documentReference.setData(from: game)
                    self.buildWallPlayer.playFromStart()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func moveChessman(currentIndex: Int, nextIndex: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
                if game.roomOwnerChessmanIndex == currentIndex {
                    game.roomOwnerChessmanIndex = nextIndex
                    if stride(from: 0, through: 16, by: 2).contains(nextIndex) {
                        game.winner = game.roomOwner
                        game.gameState = .end
                    }
                } else {
                    game.joinedPlayerChessmanIndex = nextIndex
                    if stride(from: 340, through: 356, by: 2).contains(nextIndex) {
                        game.winner = game.joinedPlayer
                        game.gameState = .end
                    }
                }
                if game.turn?.email == game.roomOwner?.email {
                    game.turn = game.joinedPlayer
                } else {
                    game.turn = game.roomOwner
                }
                do {
                    try documentReference.setData(from: game)
                    self.moveChessmanPlayer.playFromStart()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func exitGame(player: Player, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
                if game.exit == 1 {
                    documentReference.delete()
                } else {
                    game.exit += 1
                    do {
                        try documentReference.setData(from: game)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
                self.game = Game()
                if self.listener != nil {
                    self.listener!.remove()
                }
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }
    
    func giveUp(player: Player, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let roomId = game.id else { return }
        let documentReference = db.collection("games").document(roomId)
        documentReference.getDocument { document, error in
            guard let error = error else {
                guard let document = document, document.exists, var game = try? document.data(as: Game.self) else { return }
                if game.roomOwner?.email == player.email {
                    game.winner = game.joinedPlayer
                    game.gameState = .end
                } else {
                    game.winner = game.roomOwner
                    game.gameState = .end
                }
                do {
                    try documentReference.setData(from: game)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    func setVolume(volume: Float) {
        self.moveChessmanPlayer.volume = volume
        self.buildWallPlayer.volume = volume
    }
}
