//
//  DashboardModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DashboardViewModel: ObservableObject {
    @Published var showingSettings = false
    @Published var showingNotification = false
    
    init() {}
    
    
}
