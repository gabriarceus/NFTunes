//
//  NFTGraphView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 15/01/24.
//

import SwiftUI
import Charts
import FirebaseFirestoreSwift


struct NFTGraphView: View {
    @StateObject var viewModel = NftViewModel()
    let volume: [Int]
    
    var data: [DataPoints] {
        var dataPoints: [DataPoints] = []
        let days = ["15/01", "16/01", "17/01", "18/01", "19/01", "20/01", "21/01"]
        for (index, amount) in volume.enumerated() {
            let day = days[index]
            dataPoints.append(DataPoints(day: day, amount: amount))
        }
        return dataPoints
    }
    
    @State private var scale: CGFloat = 0
    
    var body: some View {
        Chart {
            ForEach (data) { d in
                BarMark(x: .value("Day", d.day), y: .value("Scambi", d.amount))
                    .annotation (position: .top) {
                        Text(String(d.amount))
                    }
            }
        }
        .chartYScale(range: .plotDimension(padding: 60))
        .padding()
        .scaledToFit()
        .scaleEffect(x: 1, y: scale, anchor: .bottom)
        .onAppear {
            withAnimation(.spring()){
                scale = 1
            }
        }
        .overlay(
            Rectangle()
                .stroke(Color.gray, lineWidth: 0.5)
                .opacity(0.5)
        )
    }
}

#Preview {
    NFTGraphView(volume: [142, 188, 93, 81, 85, 99, 150])
}
