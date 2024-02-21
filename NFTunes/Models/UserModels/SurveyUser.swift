//
//  SurveyUser.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 17/01/24.
//

import Foundation

struct SurveyUserItem: Codable, Identifiable {
    let id: String
    let description: String
    var joined: Bool
    
    mutating func setJoined(_ state: Bool){
        joined = state
    }
}
