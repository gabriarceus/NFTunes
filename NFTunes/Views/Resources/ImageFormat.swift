//
//  ImageFormat.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 11/01/24.
//

import SwiftUI

struct ImageFormat: View {
    
    let size: CGFloat
    let image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.gray, lineWidth: 1)
                )
    }
}

#Preview {
    ImageFormat(size: 150, image: "Shiva")
}
