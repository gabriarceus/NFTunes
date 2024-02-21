//
//  Badge.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 02/02/24.
//

import SwiftUI

struct Badge: View {
    let count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Text(String(count))
                .font(.system(size: 12))
                .bold()
                .padding(5)
                .background(Color.red)
                .clipShape(Circle())
            // custom positioning in the top-right corner
                .alignmentGuide(.top) { $0[.bottom] - $0.height * 1.3}
                .alignmentGuide(.trailing) { $0[.trailing] + $0.width * 1.25 }
        }
    }
}

#Preview {
    Badge(count: 5)
}
