//
//  Survey.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 17/01/24.
//

import Foundation

struct SurveyItem: Codable, Identifiable {
    let id: String
    let artist: String
    let description: String
    var yes: Int
    var no: Int
    let requirement: [String]
    let timer: TimeInterval
    
    mutating func addVote(_ state: Bool){
        if state {
            yes += 1
        } else {
            no += 1
        }
    }
}
