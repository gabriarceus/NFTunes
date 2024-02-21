//
//  SurveysGraphView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 17/01/24.
//

import SwiftUI

struct SurveysGraphView: View {
    var bar1Length: CGFloat
    var bar2Length: CGFloat
    var maxWidth: CGFloat = UIScreen.main.bounds.width - 50 // sottrai il padding

    var body: some View {
        VStack {
            HStack {
                Text("Si  ")
                    .bold()
                Color.green
                    .frame(width: ((bar1Length / max(bar1Length, bar2Length)) * maxWidth) / 2, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.white)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                Text("\(Int(bar1Length))")
                Spacer()
            }
            HStack {
                Text("No")
                    .bold()
                Color.red
                    .frame(width: ((bar2Length / max(bar1Length, bar2Length)) * maxWidth) / 2, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.white)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                Text("\(Int(bar2Length))")
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    SurveysGraphView(bar1Length: 2000, bar2Length: 150)
}
