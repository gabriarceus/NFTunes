//
//  User.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
    let nfts: Int
    let friends: Int
    let events: Int
    var image: String
}


