//
//  SurveysViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SurveysViewModel: ObservableObject {
    init() {}
    
    @Published var survey: SurveyItem? = nil
    
    func getSurvey(id: String) {
        let db = Firestore.firestore()
        db.collection("decisions")
            .document(id)
            .getDocument { [weak self] snapshot, error in // con snapshotListener si aggiorna in tempo reale (invece di .getDocument)
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.survey = SurveyItem(
                        id: data["id"] as? String ?? "",
                        artist: data["artist"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        yes: data["yes"] as? Int ?? 0,
                        no: data["no"] as? Int ?? 0,
                        requirement: data["requirement"] as? [String] ?? [],
                        timer: data["timer"] as? TimeInterval ?? 0
                    )
                }
            }
    }
    
    func addVote(item: SurveyItem, vote: Bool){
        //var newItem = item
        
        let db = Firestore.firestore()
        if vote {
            db.collection("decisions")
                .document(item.id)
                .setData([
                    "id": item.id,
                    "artist": item.artist,
                    "description": item.description,
                    "yes": item.yes + 1,
                    "no": item.no
                ], merge: true)} else {
                    db.collection("decisions")
                        .document(item.id)
                        .setData([
                            "id": item.id,
                            "artist": item.artist,
                            "description": item.description,
                            "yes": item.yes,
                            "no": item.no + 1
                        ], merge: true)
                }
    }
    
    func addSurveyId(userId: String, item: NftUserItem, surveyId: String){
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("nft")
            .document(item.id)
            .setData([
            "id": item.id,
            "date": item.date,
            "event": item.event,
            "favorite": item.fav,
            "decision": item.decision + [surveyId]
            ], merge: true)
    }
}
