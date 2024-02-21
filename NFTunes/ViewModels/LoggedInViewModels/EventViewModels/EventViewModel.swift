//
//  EventViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 16/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class EventViewModel: ObservableObject {
    init() {}
    
    @Published var event: EventItem? = nil
    
    func getEvent(id: String) {
        let db = Firestore.firestore()
        db.collection("events")
            .document(id)
            .getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.event = EventItem(
                    id: data["id"] as? String ?? "",
                    date: data["date"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    location: data["location"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    //participants: data["participants"] as? String ?? "",
                    tier1: data["tier1"] as? String ?? "",
                    tier2: data["tier2"] as? String ?? "",
                    tier3: data["tier3"] as? String ?? ""
                )
            }
        }
    }
}
