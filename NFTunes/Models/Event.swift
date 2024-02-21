//
//  Event.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 16/01/24.
//

import Foundation

struct EventItem: Codable, Identifiable {
    let id: String
    let date: String
    let name: String
    let location: String
    let description: String
    //let participants: String //da rivedere per implementarlo come un array di artisti
    let tier1: String
    let tier2: String
    let tier3: String
}
