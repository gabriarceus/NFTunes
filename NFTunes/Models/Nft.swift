//
//  Nft.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 12/01/24.
//

import Foundation

struct NftItem: Codable, Identifiable {
    let id: String
    let artist: String
    let amount: Int
    let tier: Int
    let volume: [Int]
    
}
