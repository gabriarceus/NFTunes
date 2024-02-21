//
//  KeyframeAnimationView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 25/01/24.
//

import SwiftUI
import EffectsLibrary
import AVFAudio

struct KeyframeAnimationView: View {
    
    let totalDuration: Double = 15
    let userNft: String
    let friendNft: String
    @State private var startAnimation = false
    @State private var showFireworks = false
    @StateObject var viewModel  = KeyframeAnimationViewModel()
    
    init(userNft: String, friendNft: String) {
        self.userNft = userNft
        self.friendNft = friendNft
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                
                ///Totale durata animazione: 15 secondi
                ///Inizio animazione: NFT 1 sale in alto e dopo 7,5 secondi NFT 2 scende da out of bounds per tornare al posto di NFT 1
                ///Dopo 14 secondi inizia l'animazione di fuochi d'artificio con la scritta congratulazioni
                if showFireworks {
                    FireworksView()
                        .ignoresSafeArea()
                    Text("Congratulazioni!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.black)
                    Text("Hai ottenuto l'NFT #\(friendNft)")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.black)
                    
                }
                Spacer()
                ZStack{
                    
                    Image("iphone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                        .padding()
                        .offset(y: 50)
                    
                    NftImageFormat(size: 100, image: userNft, tier: 3)
                        .keyframeAnimator(initialValue: AnimationPropertiesUser(), trigger: startAnimation) {
                            content, value in
                            content
                                .offset(y: value.yTranslation)
                        } keyframes: { _ in
                            
                            KeyframeTrack(\.yTranslation){
                                CubicKeyframe(50, duration: totalDuration * 0.05)
                                CubicKeyframe(-800, duration: totalDuration * 0.45)
                                LinearKeyframe(-1000, duration: totalDuration * 0.5)
                            }
                        }
                    
                    NftImageFormat(size: 100, image: friendNft, tier: 3)
                        .keyframeAnimator(initialValue: AnimationPropertiesFriend(), trigger: startAnimation) {
                            content, value in
                            content
                                .offset(y: value.yTranslation)
                        } keyframes: { _ in
                            
                            KeyframeTrack(\.yTranslation){
                                CubicKeyframe(-700, duration: totalDuration * 0.5)
                                CubicKeyframe(50, duration: totalDuration * 0.3)
                                CubicKeyframe(100, duration: totalDuration * 0.05)
                                CubicKeyframe(50, duration: totalDuration * 0.15)
                            }
                        }
                }
            }
            .background(
                Image("sky")
            )
        }
        .onAppear() {
            startAnimation = true
            viewModel.playSoundEvolution()
            DispatchQueue.main.asyncAfter(deadline: .now() + 14.0) {
                showFireworks = true
                viewModel.playSoundCongratulations()
            }
        }
    }
}

struct AnimationPropertiesUser {
    var yTranslation: CGFloat = 50
}

struct AnimationPropertiesFriend {
    var yTranslation: CGFloat = -900
}




#Preview {
    KeyframeAnimationView(userNft: "yL6IwvLTY3NmESKnyMhBYFgWiGD3", friendNft: "RtNpJbt4vfR8O6wUC55GaZkkTf33")
}
