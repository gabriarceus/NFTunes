//
//  NftImageFormat.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 23/01/24.
//

import SwiftUI

struct NftImageFormat: View {
    
    let size: CGFloat
    let image: String
    let tier: Int
    
    ///si potrebbe aggiungere un custom color name in color set negli assets
    var color: Color {
        switch tier {
        case 1:
            return Color.gray
        case 2:
            return Color.blue
        case 3:
            return Color.yellow
        default:
            return Color.clear
        }
    }
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Rectangle())
            .overlay(
                Rectangle()
                    .stroke(color, lineWidth: CGFloat(tier))
            )
    }
}

#Preview {
    NftImageFormat(size: 150, image: "Shiva", tier: 3)
}
