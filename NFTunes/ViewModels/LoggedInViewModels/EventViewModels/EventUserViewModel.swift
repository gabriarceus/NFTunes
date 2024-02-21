//
//  EventUserViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 17/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class EventUserViewModel: ObservableObject {
    init() {}
    /*
    func toggleIsFav(item: SurveyUserItem) {
        var newItem = item
        newItem.setJoined(!item.joined)
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("decision")
            .document(newItem.id)
            .setData(newItem.asDictionary(), merge: true)
    }
    */
}
