//
//  GameSettingsView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/8/9.
//

import SwiftUI
import AVFoundation

struct GameSettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("vibration") var vibration = true
    @AppStorage("backgroundMusicVolume") var backgroundMusicVolume = 0.5
    @AppStorage("soundEffectVolume") var soundEffectVolume = 0.5
    
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(Image(systemName: "chevron.backward"))
                        .font(.title3.bold())
                }
                
                Spacer()
            }
            .overlay {
                Text("Game")
                    .font(.title2.bold())
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 1)
                .overlay(Color.earthyGold)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Toggle(isOn: $vibration) {
                            Text("Vibrate")
                                .font(.title2.bold())
                        }
                        .tint(.lightBrown)
                        
                        Text("Music")
                            .font(.title2.bold())
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Background Music")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text(Image(systemName: backgroundMusicVolume == 0 ? "speaker.slash" : backgroundMusicVolume < 0.3 ? "speaker" : backgroundMusicVolume < 0.6 ? "speaker.wave.1" : backgroundMusicVolume < 1 ? "speaker.wave.2" : "speaker.wave.3"))
                                    .font(.title2)
                            }
                            
                            Slider(value: $backgroundMusicVolume, in: 0...1, step: 0.1) {
                                Text("volume")
                            } minimumValueLabel: {
                                Text("Low")
                            } maximumValueLabel: {
                                Text("High")
                            }
                            .tint(.lightBrown)
                            .foregroundColor(.lightBrown)
                            .onChange(of: backgroundMusicVolume) { newVolume in
                                AVPlayer.bgQueuePlayer.volume = Float(newVolume)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Sound Effect")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text(Image(systemName: soundEffectVolume == 0 ? "speaker.slash" : soundEffectVolume < 0.3 ? "speaker" : soundEffectVolume < 0.6 ? "speaker.wave.1" : soundEffectVolume < 1 ? "speaker.wave.2" : "speaker.wave.3"))
                                    .font(.title2)
                            }
                            
                            Slider(value: $soundEffectVolume, in: 0...1, step: 0.1) {
                                Text("volume")
                            } minimumValueLabel: {
                                Text("Low")
                            } maximumValueLabel: {
                                Text("High")
                            }
                            .tint(.lightBrown)
                            .foregroundColor(.lightBrown)
                            .onChange(of: soundEffectVolume) { newVolume in
                                gameViewModel.setVolume(volume: Float(newVolume))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
            }
        }
        .navigationBarHidden(true)
        .foregroundColor(.white)
        .background(Color.backgroundColor)
    }
}
