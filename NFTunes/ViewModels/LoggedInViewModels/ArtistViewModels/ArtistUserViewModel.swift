//
//  ArtistsViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ArtistUserViewModel: ObservableObject {
    init() {}
    
    func toggleIsFav(item: ArtistUserItem) {
        var newItem = item
        newItem.setFav(!item.fav)
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("artist")
            .document(newItem.id)
            .setData(newItem.asDictionary(), merge: true)
    }
}
