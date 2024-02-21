//
//  Artist.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 16/01/24.
//

import Foundation

struct ArtistItem: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let event: [String]
    
}
