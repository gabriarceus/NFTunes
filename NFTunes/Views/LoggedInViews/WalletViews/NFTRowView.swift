//
//  NFTViews.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 12/01/24.
//

import SwiftUI

struct NFTRowView: View {
    let item: NftUserItem
    let tier: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text("NFT #" + item.id)
                    .bold()
                Text("Ottenuto il: \(item.date)")
            }
            Spacer()
            if item.fav {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            
            NftImageFormat(size: 50, image: item.id, tier: tier)
        }
    }
}

#Preview {
    NFTRowView(item: .init(id: "1234", date: "12/01/2024", event:"e001", fav: true, decision: [""]), tier: 1)
}
