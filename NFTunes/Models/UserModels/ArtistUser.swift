//
//  ArtistUser.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 16/01/24.
//

import Foundation

struct ArtistUserItem: Codable, Identifiable {
    let id: String
    let name: String
    var fav: Bool
    
    mutating func setFav(_ state: Bool){
        fav = state
    }
}
