//
//  Trade.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 31/01/24.
//

import Foundation

struct TradingInformation: Codable, Identifiable, Equatable {
    let id: String
    let date: TimeInterval
    let userName: String
    let offeredNftId: String
    let requestedNftId: String
    var confirmed: Bool
    
    mutating func isConfirmed(_ state: Bool){
        confirmed = state
    }
}
