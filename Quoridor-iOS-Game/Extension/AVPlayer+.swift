//
//  AVPlayer+.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/8.
//

import AVFoundation

extension AVPlayer {
    
    static var bgQueuePlayer = AVQueuePlayer()
    static var bgPlayerLooper: AVPlayerLooper!
    
    static let buildWallPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "Build Wall", withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    
    static let moveChessmanPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "Move Chessman", withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    
    static func setupBgMusic() {
        guard let url = Bundle.main.url(forResource: "At Home", withExtension: "m4a") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
    
    func playFromStart() {
        seek(to: .zero)
        play()
    }
}
