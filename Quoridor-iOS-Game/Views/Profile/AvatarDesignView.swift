//
//  AvatarDesignView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/2.
//

import SwiftUI

struct AvatarDesignView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    
    @Binding var isDesignAvatar: Bool
    
    @AppStorage("avartarBackgroundColor") var avartarBackgroundColor = Color.obsidianGrey
    @AppStorage("avatarSet") var avatarSet = [0, 0, 0, 0, 0, 0] // body, eye, mouth, arm, accesory, leg
    
    @State private var uiImage: UIImage?
    @State private var tempAvatarSet = [0, 0, 0, 0, 0, 0] // body, eye, mouth, arm, accesory, leg
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var isErrorOccured = false
    
    enum BodyPart: Int, CaseIterable {
        case body, eye, mouth, arm, accesory, leg
        
        var description: String {
            switch self {
            case .body: return "body"
            case .eye: return "eye"
            case .mouth: return "mouth"
            case .arm: return "arm"
            case .accesory: return "accesory"
            case .leg: return "leg"
            }
        }
        var systemName: String {
            switch self {
            case .body: return "tshirt"
            case .eye: return "eyes"
            case .mouth: return "mouth"
            case .arm: return "hand.raised"
            case .accesory: return "crown"
            case .leg: return "pawprint"
            }
        }
        var fillName: String {
            switch self {
            case .body: return ".fill"
            case .eye: return ".inverse"
            case .mouth: return ".fill"
            case .arm: return ".fill"
            case .accesory: return ".fill"
            case .leg: return ".fill"
            }
        }
    }
    @State private var selectBodyPart: BodyPart = .body
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button {
                        isDesignAvatar = false
                    } label: {
                        Text("Cancel")
                            .font(.title3)
                            .opacity(0.85)
                    }
                    
                    Spacer()
                    
                    Button {
                        isLoading = true
                        uiImage = AvatarView(tempAvatarSet: tempAvatarSet).snapshot()
                        if let uiImage = uiImage {
                            let currentPlayer = playerViewModel.currentPlayer
                            playerViewModel.uploadAvatar(image: uiImage) { result in
                                switch result {
                                case .success(let avatarUrl):
                                    avatarSet = tempAvatarSet
                                    authViewModel.updateUser(name: currentPlayer.name, email: currentPlayer.email, avatar: avatarUrl) { result in
                                        if case .failure(let error) = result {
                                            errorMessage = error.localizedDescription
                                            isErrorOccured = true
                                        }
                                    }
                                    playerViewModel.updatePlayer(name: currentPlayer.name, email: currentPlayer.email, zodiacSign: currentPlayer.zodiacSign, age: currentPlayer.age, avatar: avatarUrl) { result in
                                        if case .failure(let error) = result {
                                            errorMessage = error.localizedDescription
                                            isErrorOccured = true
                                        }
                                    }
                                    isDesignAvatar = false
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
                                    isErrorOccured = true
                                }
                            }
                        } else {
                            errorMessage = "Can't generate avatar successfully."
                            isErrorOccured = true
                        }
                    } label: {
                        Text("Done")
                            .font(.title3.bold())
                            .foregroundColor(.lightBrown)
                    }
                }
                .overlay {
                    Text("Design Avatar")
                        .font(.title2.bold())
                }
                .padding(.top)
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.earthyGold)
                
                VStack {
                    AvatarView(tempAvatarSet: tempAvatarSet)
                        .overlay(alignment: .bottomTrailing) {
                            ColorPicker("", selection: $avartarBackgroundColor)
                                .shadow(radius: 10)
                                .padding(10)
                        }
                        .padding(.vertical, 10)
                    
                    ScrollViewReader { scrollView in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        avartarBackgroundColor = .random
                                        for bodyPart in BodyPart.allCases {
                                            if [.body, .eye, .arm].contains(bodyPart) {
                                                tempAvatarSet[bodyPart.rawValue] = (0...8).randomElement()!
                                            } else {
                                                tempAvatarSet[bodyPart.rawValue] = (0...9).randomElement()!
                                            }
                                        }
                                    }
                                } label: {
                                    Text(Image(systemName: "dice.fill"))
                                        .font(.title.bold())
                                        .foregroundColor(.red)
                                        .frame(width: 60, height: 60)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.lightBrown)
                                        }
                                }
                                
                                ForEach(BodyPart.allCases, id: \.self) { bodyPart in
                                    Button {
                                        withAnimation {
                                            selectBodyPart = bodyPart
                                        }
                                    } label: {
                                        Text(Image(systemName: "\(bodyPart.systemName)\(selectBodyPart == bodyPart ? bodyPart.fillName : "")"))
                                            .font(selectBodyPart == bodyPart ? .title.bold() : .title)
                                            .foregroundColor(selectBodyPart == bodyPart ? .white : .roseGold)
                                            .frame(width: 60, height: 60)
                                            .background {
                                                if selectBodyPart == bodyPart {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .foregroundColor(.roseGold)
                                                } else {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.roseGold, lineWidth: 2.5)
                                                }
                                            }
                                    }
                                    .id(bodyPart)
                                }
                            }
                        }
                        .onChange(of: selectBodyPart) { _ in
                            scrollView.scrollTo(selectBodyPart)
                        }
                    }
                    .padding(.bottom, 5)
                    
                    TabView(selection: $selectBodyPart) {
                        ForEach(BodyPart.allCases, id: \.self) { bodyPart in
                            ScrollView(showsIndicators: false) {
                                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10) {
                                    ForEach(0...9, id: \.self) { index in
                                        Button {
                                            tempAvatarSet[bodyPart.rawValue] = index
                                        } label: {
                                            if index < 9 {
                                                Image("\(bodyPart.description)-\(index)")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .background {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundColor(.middleBrown)
                                                    }
                                            } else if [.mouth, .accesory, .leg].contains(bodyPart) {
                                                Image(systemName: "slash.circle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.roseGold)
                                                    .padding(25)
                                                    .background {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundColor(.middleBrown)
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .padding(.horizontal)
            }
            .background(Color.backgroundColor)
            .onAppear {
                tempAvatarSet = avatarSet
            }
            .overlay {
                LoadingView(isLoading: $isLoading, errorMessage: $errorMessage, isErrorOccured: $isErrorOccured, geometry: geometry)
            }
        }
    }
}

struct AvatarView: View {
    
    @AppStorage("avartarBackgroundColor") var avartarBackgroundColor = Color.obsidianGrey
    
    let tempAvatarSet: [Int]
    
    var body: some View {
        ZStack {
            Image("leg-\(tempAvatarSet[5])")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .offset(x: -1, y: 70)
            
            Image("body-\(tempAvatarSet[0])")
                .resizable()
                .scaledToFit()
                .frame(width: 230, height: 230)
            
            Image("accesory-\(tempAvatarSet[4])")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .offset(y: -75)
            
            Image("eye-\(tempAvatarSet[1])")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .offset(y: -25)
            
            Image("mouth-\(tempAvatarSet[2])")
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 65)
                .offset(y: 15)
            
            Image("arm-\(tempAvatarSet[3])")
                .resizable()
                .scaledToFit()
                .frame(width: 255, height: 255)
                .offset(x: -2.5, y: -4)
        }
        .frame(width: 250, height: 250)
        .background(avartarBackgroundColor)
        .cornerRadius(5)
    }
}
