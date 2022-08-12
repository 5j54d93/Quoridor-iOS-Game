//
//  GamingPlayer.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/11.
//

import Foundation
import FirebaseFirestoreSwift

struct GamingPlayer: Codable {
    var id: String
    var name: String
    var star: Int
    var lastWall = 10
    var chessmanIndex: Int
    var winRate: Double
    var avatar: URL
}
