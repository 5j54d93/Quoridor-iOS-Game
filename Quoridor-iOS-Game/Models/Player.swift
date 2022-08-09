//
//  Player.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/6/30.
//

import Foundation
import FirebaseFirestoreSwift

struct Player: Codable, Identifiable, Hashable {
    
    @DocumentID var id: String?
    
    enum zodiacSignType: Codable, CaseIterable {
        case notSet, aquarius, pisces, aries, taurus, gemini, cancer, leo, virgo, libra, scorpio, sagittarius, capricorn
        
        var description: String {
            switch self {
            case .notSet: return "not set"
            case .aquarius: return "Aquarius"
            case .pisces: return "Pisces"
            case .aries: return "Aries"
            case .taurus: return "Taurus"
            case .gemini: return "Gemini"
            case .cancer: return "Cancer"
            case .leo: return "Leo"
            case .virgo: return "Virgo"
            case .libra: return "Libra"
            case .scorpio: return "Scorpio"
            case .sagittarius: return "Sagittarius"
            case .capricorn: return "Capricorn"
            }
          }
    }
    
    var email: String
    var name: String
    var avatar: URL?
    var zodiacSign: zodiacSignType
    var money: Int
    var star: Int
    var maxStar: Int
    var age: Int
    var played: Int
    var win: Int
    var winRate: Double
    var haveGottenReward: Bool
    var lastAdPlayed: Date?
    
    let joined: Date
}
