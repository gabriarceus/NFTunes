//
//  NFTButton.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import SwiftUI

struct NFTButton: View {
    
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(background)
                
                Text(title)
                    .bold()
                    .foregroundStyle(.white)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .gray, radius: 3, x: 0, y: 1)
        )
        .padding()
    }
}

#Preview {
    NFTButton(title: "Value", background: .blue) {
        //Action
    }
}
