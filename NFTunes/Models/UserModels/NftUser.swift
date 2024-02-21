//
//  NftUser.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 16/01/24.
//

import Foundation

struct NftUserItem: Codable, Identifiable {
    let id: String
    let date: String
    let event: String
    var fav: Bool
    var decision: [String]
    
    mutating func setFav(_ state: Bool){
        fav = state
    }
    
    mutating func addSurveyId(_ id: String){
        decision.append(id)
    }
}
