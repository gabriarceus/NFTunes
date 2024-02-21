//
//  WalletViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class WalletViewModel: ObservableObject {
    init() {}
    
    @Published var currentUserID: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
}
