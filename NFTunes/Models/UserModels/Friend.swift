//
//  Friend.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 18/01/24.
//

import Foundation

struct FriendItem: Codable, Identifiable {
    let id: String
    let name: String
    var status: Bool
    var friendRequest: Bool
    
    mutating func setStatus(_ state: Bool) {
        self.status = state
    }
    
    mutating func setFriendRequest(_ state: Bool) {
        self.friendRequest = state
    }
}
