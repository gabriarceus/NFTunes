//
//  NftViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 15/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NftUserViewModel: ObservableObject {
    
    init() {}
    
    // così cambia stato
    func toggleIsFav(item: NftUserItem) {
        var newItem = item
        newItem.setFav(!item.fav)
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("nft")
            .document(newItem.id)
            .setData(newItem.asDictionary(), merge: true)
    }
}
