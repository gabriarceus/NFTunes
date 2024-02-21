//
//  SurveysUserViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 17/01/24.
//

///QUA SOLITAMENTE VA IL PULSANTE PER CAMBIARE IL PREFERITO
import Foundation
import FirebaseAuth
import FirebaseFirestore


class SurveysUserViewModel: ObservableObject {
    @Published var surveyUserItem: SurveyUserItem? = nil //per aggiornare la view
    
    init() {}
    
    func switchToVoted(item: SurveyUserItem) {
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
        
        // Aggiorna l'elemento pubblicato
        self.surveyUserItem = newItem
    }
}
