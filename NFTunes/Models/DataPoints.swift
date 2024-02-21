//
//  DataPoints.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 15/01/24.
//

import Foundation

struct DataPoints: Identifiable {
    var id = UUID().uuidString
    var day: String
    var amount: Int
}
