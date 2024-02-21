//
//  KeyframeAnimationViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 26/01/24.
//

import Foundation
import AVFAudio
import SwiftUI

class KeyframeAnimationViewModel: ObservableObject {
    
    init() {}
    
    let evolutionSound = "evolution"
    let congratulationsSound = "congratulations"
    @Published private var audioPlayer: AVAudioPlayer! //non c'è ancora qua
    
    
    func playSoundEvolution() {
        guard let soundFile = NSDataAsset(name: evolutionSound) else {
            print("😡 Asset not found \(evolutionSound)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 Couldn't play \(error.localizedDescription)")
        }
    }
    
    func playSoundCongratulations() {
        guard let soundFile = NSDataAsset(name: congratulationsSound) else {
            print("😡 Asset not found \(congratulationsSound)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 Couldn't play \(error.localizedDescription)")
        }
    }
}
