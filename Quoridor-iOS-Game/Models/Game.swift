//
//  Game.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/16.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Game: Codable {
    
    @DocumentID var id: String?
    
    enum GameType: Codable {
        case null, rank, casual
        
        var description: String {
            switch self {
            case .null: return "loading..."
            case .rank: return "Rank"
            case .casual: return "Casual"
            }
        }
        var foregroundColor: Color {
            switch self {
            case .null: return .middleBrown
            case .rank: return .roseGold
            case .casual: return .earthyGold
            }
        }
        var symbol: Image {
            switch self {
            case .null: return Image(systemName: "")
            case .rank: return Image(systemName: "flag.filled.and.flag.crossed")
            case .casual: return Image(systemName: "person.2.fill")
            }
        }
    }
    enum GameState: Codable { case unCreate, waiting, matching, playing, end }
    
    var gameType: GameType = .null
    var gameState: GameState = .unCreate
    var isReadyToPlay = false
    var wall: [Int] = []
    var exit = 0
    var roomOwner: GamingPlayer?
    var joinedPlayer: GamingPlayer?
    var turn: String?
    var winner: String?
}
