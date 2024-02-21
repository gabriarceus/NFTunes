//
//  Notification.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 30/01/24.
//

import Foundation

struct NotificationItem: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let date: TimeInterval //Date().timeIntervalSince1970
    var read: Bool
    let senderId: String
    let senderName: String
    
    mutating func setRead(_ state: Bool){
        read = state
    }
}
