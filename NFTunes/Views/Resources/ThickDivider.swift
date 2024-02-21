//
//  ThickDivider.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 06/02/24.
//

import SwiftUI

struct ThickDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.secondary)
            .frame(height: 1)
            .opacity(0.5)
    }
}

#Preview {
    ThickDivider()
}
