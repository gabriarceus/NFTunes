//
//  ArtistViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 16/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ArtistViewModel: ObservableObject {
    init() {}
    
    @Published var artist: ArtistItem? = nil
    
    func getArtist(id: String) {
        let db = Firestore.firestore()
        db.collection("artists")
            .document(id)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.artist = ArtistItem(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        event: data["event"] as? [String] ?? []
                    )
                }
            }
    }
    
}
