//
//  Color+.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/1.
//

import SwiftUI

extension Color: RawRepresentable {
    
    static let backgroundColor = Color("backgroundColor")
    static let lightBrown = Color("lightBrown")
    static let middleBrown = Color("middleBrown")
    static let darkBrown = Color("darkBrown")
    static let earthyGold = Color("earthyGold")
    static let roseGold = Color("roseGold")
    static let obsidianGrey = Color("obsidianGrey")
    
    static var random: Color {
        return Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
    
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .black
            return
        }
        
        do {
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            self = Color(color)
        } catch {
            self = .black
        }
    }
    
    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}
