//
//  GameView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/21.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var playerViewModel: PlayerViewModel
    @ObservedObject var gameViewModel: GameViewModel
    
    @Binding var appState: ContentView.AppStateType
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    @State private var geoWidth: CGFloat = 0
    @State private var isMovingChessman = false
    @State private var isBuildingWall = false
    @State private var wallIndexes: [Int] = []
    @State private var currentIndex = -1
    @State private var nextMoves: [Int] = []
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        appState = .gameSetting
                    }
                } label: {
                    Image(systemName: "gearshape.circle")
                        .resizable()
                        .scaledToFit()
                        .background {
                            Circle()
                                .foregroundColor(.white.opacity(0.33))
                        }
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .trailing) {
                        Text(gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id ? gameViewModel.game.joinedPlayer?.name ?? "" : gameViewModel.game.roomOwner?.name ?? "")
                            .font(.title2.bold())
                        
                        Text(gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id ? "\(gameViewModel.game.joinedPlayer?.lastWall ?? 0) Wall " : "\(gameViewModel.game.roomOwner?.lastWall ?? 0) Wall ")
                        +
                        Text(Image(systemName: "circle.fill"))
                            .foregroundColor(gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id ? .red : .blue)
                    }
                    
                    AsyncImage(url: gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id ? gameViewModel.game.joinedPlayer?.avatar : gameViewModel.game.roomOwner?.avatar) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray
                            .overlay {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .lightBrown))
                            }
                    }
                    
                    .clipShape(Circle())
                }
                .padding(.leading, 16)
                .padding(.trailing, 6)
                .padding(.vertical, 3)
                .background {
                    Capsule()
                        .foregroundColor(.white.opacity(0.33))
                        .overlay {
                            Capsule()
                                .stroke(
                                    gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id
                                    ? gameViewModel.game.turn == gameViewModel.game.joinedPlayer?.id
                                    ? Color.red
                                    : Color.clear
                                    : gameViewModel.game.turn == gameViewModel.game.roomOwner?.id
                                    ? Color.blue
                                    : Color.clear
                                    , lineWidth: 3)
                        }
                }
            }
            .frame(height: 45)
            
            Spacer()
            
            VStack(spacing: 0) {
                ForEach(0...20, id: \.self) { row -> AnyView in
                    if row % 2 == 0 {
                        return AnyView (
                            HStack(spacing: 0) {
                                ForEach(17*row...17*row+16, id: \.self) { index in
                                    if index % 2 == 0 {
                                        Rectangle()
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(.roseGold)
                                            .overlay {
                                                if nextMoves.contains(index) {
                                                    Color.white
                                                        .opacity(opacity)
                                                        .onAppear {
                                                            opacity = 0.3
                                                        }
                                                        .onDisappear {
                                                            opacity = 0
                                                        }
                                                        .animation(.easeInOut.repeatForever(autoreverses: true), value: opacity)
                                                }
                                                if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index) {
                                                    Circle()
                                                        .strokeBorder(.white, lineWidth: isMovingChessman && currentIndex == index ? 2 : 0)
                                                        .background(Circle().foregroundColor(gameViewModel.game.roomOwner?.chessmanIndex == index ? .blue : .red) )
                                                        .onTapGesture {
                                                            wallIndexes = []
                                                            isBuildingWall = false
                                                            if !isMovingChessman {
                                                                if gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id && gameViewModel.game.roomOwner?.chessmanIndex == index || gameViewModel.game.joinedPlayer?.id == playerViewModel.currentPlayer.id && gameViewModel.game.joinedPlayer?.chessmanIndex == index {
                                                                    currentIndex = index
                                                                    nextMoves = []
                                                                    if index == 0 {
                                                                        nextMoves.append(2)
                                                                        if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(34) {
                                                                            if !gameViewModel.game.wall.contains(35) {
                                                                                nextMoves.append(36)
                                                                            }
                                                                            if !gameViewModel.game.wall.contains(51) {
                                                                                nextMoves.append(68)
                                                                            }
                                                                        } else {
                                                                            nextMoves.append(34)
                                                                        }
                                                                    } else if index == 16 {
                                                                        nextMoves.append(14)
                                                                        if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(50) {
                                                                            if !gameViewModel.game.wall.contains(49) {
                                                                                nextMoves.append(48)
                                                                            }
                                                                            if !gameViewModel.game.wall.contains(67) {
                                                                                nextMoves.append(84)
                                                                            }
                                                                        } else {
                                                                            nextMoves.append(50)
                                                                        }
                                                                    } else if index == 340 {
                                                                        nextMoves.append(342)
                                                                        if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(306) {
                                                                            if !gameViewModel.game.wall.contains(289) {
                                                                                nextMoves.append(272)
                                                                            }
                                                                            if !gameViewModel.game.wall.contains(307) {
                                                                                nextMoves.append(308)
                                                                            }
                                                                        } else {
                                                                            nextMoves.append(306)
                                                                        }
                                                                    } else if index == 356 {
                                                                        nextMoves.append(354)
                                                                        if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(322) {
                                                                            if !gameViewModel.game.wall.contains(321) {
                                                                                nextMoves.append(320)
                                                                            }
                                                                            if !gameViewModel.game.wall.contains(305) {
                                                                                nextMoves.append(288)
                                                                            }
                                                                        } else {
                                                                            nextMoves.append(322)
                                                                        }
                                                                    } else if stride(from: 2, through: 14, by: 2).contains(index) {
                                                                        nextMoves = [index-2, index+2]
                                                                        if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index+34) {
                                                                            if !gameViewModel.game.wall.contains(index+33) {
                                                                                nextMoves.append(index+32)
                                                                            }
                                                                            if !gameViewModel.game.wall.contains(index+35) {
                                                                                nextMoves.append(index+36)
                                                                            }
                                                                            if !gameViewModel.game.wall.contains(index+51) {
                                                                                nextMoves.append(index+68)
                                                                            }
                                                                        } else {
                                                                            nextMoves.append(index+34)
                                                                        }
                                                                    } else if stride(from: 34, through: 306, by: 34).contains(index) {
                                                                        if !gameViewModel.game.wall.contains(index-17) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index-34) {
                                                                                if !gameViewModel.game.wall.contains(index-51) {
                                                                                    nextMoves.append(index-68)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index-33) {
                                                                                    nextMoves.append(index-32)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index-34)
                                                                            }
                                                                        }
                                                                        if !gameViewModel.game.wall.contains(index+17) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index+34) {
                                                                                if !gameViewModel.game.wall.contains(index+35) {
                                                                                    nextMoves.append(index+36)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+51) {
                                                                                    nextMoves.append(index+68)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index+34)
                                                                            }
                                                                        }
                                                                        if !gameViewModel.game.wall.contains(index+1) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index+2) {
                                                                                if !gameViewModel.game.wall.contains(index-15) {
                                                                                    nextMoves.append(index-32)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+3) {
                                                                                    nextMoves.append(index+4)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+19) {
                                                                                    nextMoves.append(index+36)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index+2)
                                                                            }
                                                                        }
                                                                    } else if stride(from: 50, through: 322, by: 34).contains(index) {
                                                                        if !gameViewModel.game.wall.contains(index-17) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index-34) {
                                                                                if !gameViewModel.game.wall.contains(index-51) {
                                                                                    nextMoves.append(index-68)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index-35) {
                                                                                    nextMoves.append(index-36)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index-34)
                                                                            }
                                                                        }
                                                                        if !gameViewModel.game.wall.contains(index+17) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index+34) {
                                                                                if !gameViewModel.game.wall.contains(index+33) {
                                                                                    nextMoves.append(index+32)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+51) {
                                                                                    nextMoves.append(index+68)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index+34)
                                                                            }
                                                                        }
                                                                        if !gameViewModel.game.wall.contains(index-1) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index-2) {
                                                                                if !gameViewModel.game.wall.contains(index-19) {
                                                                                    nextMoves.append(index-36)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index-3) {
                                                                                    nextMoves.append(index-4)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+15) {
                                                                                    nextMoves.append(index+32)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index-2)
                                                                            }
                                                                        }
                                                                    } else if stride(from: 342, through: 354, by: 2).contains(index) {
                                                                        nextMoves = [index-2, index+2]
                                                                        if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index-34) {
                                                                            if !gameViewModel.game.wall.contains(index-35) {
                                                                                nextMoves.append(index-36)
                                                                            }
                                                                            if !gameViewModel.game.wall.contains(index-33) {
                                                                                nextMoves.append(index-32)
                                                                            }
                                                                            if !gameViewModel.game.wall.contains(index-51) {
                                                                                nextMoves.append(index-68)
                                                                            }
                                                                        } else {
                                                                            nextMoves.append(index-34)
                                                                        }
                                                                    } else {
                                                                        if !gameViewModel.game.wall.contains(index-17) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index-34) {
                                                                                if !gameViewModel.game.wall.contains(index-35) {
                                                                                    nextMoves.append(index-36)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index-33) {
                                                                                    nextMoves.append(index-32)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index-51) {
                                                                                    nextMoves.append(index-68)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index-34)
                                                                            }
                                                                        }
                                                                        if !gameViewModel.game.wall.contains(index+17) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index+34) {
                                                                                if !gameViewModel.game.wall.contains(index+33) {
                                                                                    nextMoves.append(index+32)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+35) {
                                                                                    nextMoves.append(index+36)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+51) {
                                                                                    nextMoves.append(index+68)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index+34)
                                                                            }
                                                                        }
                                                                        if !gameViewModel.game.wall.contains(index-1) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index-2) {
                                                                                if !gameViewModel.game.wall.contains(index-19) {
                                                                                    nextMoves.append(index-36)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index-3) {
                                                                                    nextMoves.append(index-4)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+15) {
                                                                                    nextMoves.append(index+32)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index-2)
                                                                            }
                                                                        }
                                                                        if !gameViewModel.game.wall.contains(index+1) {
                                                                            if [gameViewModel.game.roomOwner?.chessmanIndex, gameViewModel.game.joinedPlayer?.chessmanIndex].contains(index+2) {
                                                                                if !gameViewModel.game.wall.contains(index-15) {
                                                                                    nextMoves.append(index-32)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+3) {
                                                                                    nextMoves.append(index+4)
                                                                                }
                                                                                if !gameViewModel.game.wall.contains(index+19) {
                                                                                    nextMoves.append(index+36)
                                                                                }
                                                                            } else {
                                                                                nextMoves.append(index+2)
                                                                            }
                                                                        }
                                                                    }
                                                                    isMovingChessman = true
                                                                }
                                                            } else {
                                                                currentIndex = -1
                                                                nextMoves = []
                                                                isMovingChessman = false
                                                            }
                                                        }
                                                }
                                            }
                                            .onTapGesture {
                                                if nextMoves.contains(index) {
                                                    appState = .loading
                                                    gameViewModel.moveChessman(currentIndex: currentIndex, nextIndex: index) { result in
                                                        switch result {
                                                        case .success():
                                                            appState = .null
                                                            currentIndex = -1
                                                            nextMoves = []
                                                            isMovingChessman = false
                                                        case .failure(let error):
                                                            alertTitle = "ERROR"
                                                            alertMessage = error.localizedDescription
                                                            appState = .alert
                                                        }
                                                    }
                                                }
                                            }
                                    } else {
                                        Rectangle()
                                            .frame(width: 10)
                                            .foregroundColor(
                                                gameViewModel.game.wall.contains(index)
                                                ? .lightBrown
                                                : isBuildingWall && wallIndexes.contains(index)
                                                ? .lightBrown.opacity(0.66)
                                                : .middleBrown
                                            )
                                            .onTapGesture {
                                                currentIndex = -1
                                                nextMoves = []
                                                isMovingChessman = false
                                                if ![0, 20].contains(row) {
                                                    if playerViewModel.currentPlayer.id == gameViewModel.game.roomOwner?.id && gameViewModel.game.roomOwner!.lastWall > 0 || playerViewModel.currentPlayer.id == gameViewModel.game.joinedPlayer?.id && gameViewModel.game.joinedPlayer!.lastWall > 0 {
                                                        if stride(from: 35, through: 49, by: 2).contains(index) {
                                                            if !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index+17) && !gameViewModel.game.wall.contains(index+34) {
                                                                isBuildingWall = true
                                                                wallIndexes = [index, index+17, index+34]
                                                            }
                                                        } else if stride(from: 307, through: 321, by: 2).contains(index) {
                                                            if !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index-17) && !gameViewModel.game.wall.contains(index-34) {
                                                                isBuildingWall = true
                                                                wallIndexes = [index, index-17, index-34]
                                                            }
                                                        } else {
                                                            if !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index+17) && !gameViewModel.game.wall.contains(index+34) {
                                                                isBuildingWall = true
                                                                wallIndexes = [index, index+17, index+34]
                                                            } else if !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index-17) && !gameViewModel.game.wall.contains(index-34) {
                                                                isBuildingWall = true
                                                                wallIndexes = [index, index-17, index-34]
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                    }
                                }
                            }.frame(height: [0, 20].contains(row) ? geoWidth*2 : geoWidth)
                        )
                    } else if [1, 19].contains(row) {
                        return AnyView (
                            Capsule()
                                .frame(height: 10)
                                .foregroundColor(.white.opacity(0.66))
                        )
                    } else {
                        return AnyView (
                            HStack(spacing: 0) {
                                ForEach(17*row...17*row+16, id: \.self) { index in
                                    if index % 2 == 1 {
                                        GeometryReader { geometry in
                                            Rectangle()
                                                .frame(maxWidth: .infinity)
                                                .foregroundColor(
                                                    gameViewModel.game.wall.contains(index)
                                                    ? .lightBrown
                                                    : isBuildingWall && wallIndexes.contains(index)
                                                    ? .lightBrown.opacity(0.66)
                                                    : .middleBrown
                                                )
                                                .onAppear {
                                                    if geoWidth == 0 {
                                                        geoWidth = geometry.size.width
                                                    }
                                                }
                                                .onTapGesture {
                                                    currentIndex = -1
                                                    nextMoves = []
                                                    isMovingChessman = false
                                                    if playerViewModel.currentPlayer.id == gameViewModel.game.roomOwner?.id && gameViewModel.game.roomOwner!.lastWall > 0 || playerViewModel.currentPlayer.id == gameViewModel.game.joinedPlayer?.id && gameViewModel.game.joinedPlayer!.lastWall > 0 {
                                                        if stride(from: 51, through: 289, by: 34).contains(index) {
                                                            if !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index+1) && !gameViewModel.game.wall.contains(index+2) {
                                                                isBuildingWall = true
                                                                wallIndexes = [index, index+1, index+2]
                                                            }
                                                        } else if stride(from: 67, through: 305, by: 34).contains(index) {
                                                            if !gameViewModel.game.wall.contains(index-2) && !gameViewModel.game.wall.contains(index-1) && !gameViewModel.game.wall.contains(index) {
                                                                isBuildingWall = true
                                                                wallIndexes = [index-2, index-1, index]
                                                            }
                                                        } else {
                                                            if !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index+1) && !gameViewModel.game.wall.contains(index+2) {
                                                                isBuildingWall = true
                                                                wallIndexes = [index, index+1, index+2]
                                                            } else if !gameViewModel.game.wall.contains(index-2) && !gameViewModel.game.wall.contains(index-1) && !gameViewModel.game.wall.contains(index) {
                                                                isBuildingWall = true
                                                                wallIndexes = [index-2, index-1, index]
                                                            }
                                                        }
                                                    }
                                                }
                                        }
                                    } else {
                                        Rectangle()
                                            .frame(width: 10)
                                            .foregroundColor(
                                                gameViewModel.game.wall.contains(index)
                                                ? .lightBrown
                                                : isBuildingWall && wallIndexes.contains(index)
                                                ? .lightBrown.opacity(0.66)
                                                : .middleBrown
                                            )
                                            .onTapGesture {
                                                currentIndex = -1
                                                nextMoves = []
                                                isMovingChessman = false
                                                if playerViewModel.currentPlayer.id == gameViewModel.game.roomOwner?.id && gameViewModel.game.roomOwner!.lastWall > 0 || playerViewModel.currentPlayer.id == gameViewModel.game.joinedPlayer?.id && gameViewModel.game.joinedPlayer!.lastWall > 0 {
                                                    if wallIndexes.contains(index) {
                                                        if wallIndexes.contains(index-1) {
                                                            if !gameViewModel.game.wall.contains(index-17) && !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index+17) {
                                                            wallIndexes = [index-17, index, index+17]
                                                            }
                                                        } else {
                                                            if !gameViewModel.game.wall.contains(index-1) && !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index+1) {
                                                                wallIndexes = [index-1, index, index+1]
                                                            }
                                                        }
                                                    } else {
                                                        if !gameViewModel.game.wall.contains(index-1) && !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index+1) {
                                                            isBuildingWall = true
                                                            wallIndexes = [index-1, index, index+1]
                                                        } else if !gameViewModel.game.wall.contains(index-17) && !gameViewModel.game.wall.contains(index) && !gameViewModel.game.wall.contains(index+17) {
                                                            wallIndexes = [index-17, index, index+17]
                                                        }
                                                    }
                                                }
                                            }
                                    }
                                }
                            }.frame(height: 10)
                        )
                    }
                }
            }
            .rotationEffect(.degrees(gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id ? 0 : 180))
            .disabled(gameViewModel.game.turn != playerViewModel.currentPlayer.id)
            
            Spacer()
            
            HStack(alignment: .bottom) {
                HStack {
                    AsyncImage(url: playerViewModel.currentPlayer.avatar) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray
                            .overlay {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .lightBrown))
                            }
                    }
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(playerViewModel.currentPlayer.name)
                            .font(.title2.bold())
                        
                        (Text(Image(systemName: "circle.fill"))
                            .foregroundColor(gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id ? .blue : .red)
                         +
                         Text(gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id ? " Wall \(gameViewModel.game.roomOwner?.lastWall ?? 0)" : " Wall \(gameViewModel.game.joinedPlayer?.lastWall ?? 0)"))
                    }
                }
                .padding(.leading, 6)
                .padding(.trailing, 16)
                .padding(.vertical, 3)
                .background {
                    Capsule()
                        .foregroundColor(.white.opacity(0.33))
                        .overlay {
                            Capsule()
                                .stroke(
                                    gameViewModel.game.roomOwner?.id == playerViewModel.currentPlayer.id
                                    ? gameViewModel.game.turn == gameViewModel.game.roomOwner?.id
                                    ? Color.blue
                                    : Color.clear
                                    : gameViewModel.game.turn == gameViewModel.game.joinedPlayer?.id
                                    ? Color.red
                                    : Color.clear
                                , lineWidth: 3)
                        }
                }
                
                Spacer()
                
                if isBuildingWall {
                    Button {
                        appState = .loading
                        gameViewModel.buildWall(indexes: wallIndexes) { result in
                            switch result {
                            case .success():
                                appState = .null
                                wallIndexes = []
                                isBuildingWall = false
                            case .failure(let error):
                                alertTitle = "ERROR"
                                alertMessage = error.localizedDescription
                                appState = .alert
                            }
                        }
                    } label: {
                        Text("Build Wall")
                            .font(.title3.bold())
                            .foregroundColor(.lightBrown)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 15)
                            .background {
                                Capsule()
                                    .stroke(Color.lightBrown, lineWidth: 3)
                            }
                    }
                }
            }
            .frame(height: 45)
        }
        .background {
            Color.backgroundColor
                .onTapGesture {
                    wallIndexes = []
                    isBuildingWall = false
                    currentIndex = -1
                    nextMoves = []
                    isMovingChessman = false
                }
        }
    }
}
