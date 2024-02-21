//
//  NftViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 16/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class NftViewModel: ObservableObject {
    init() {}
    
    @Published var nft: NftItem? = nil
    @Published var userNft: NftUserItem? = nil
    
    ///Funzione che fa il fetch dell'NFT
    func getNft(id: String) {
        let db = Firestore.firestore()
        db.collection("nfts")
            .document(id)
            .getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.nft = NftItem(
                    id: data["id"] as? String ?? "",
                    artist: data["artist"] as? String ?? "",
                    amount: data["amount"] as? Int ?? 0,
                    tier: data["tier"] as? Int ?? 0,
                    volume: data["volume"] as? [Int] ?? []
                )
            }
        }
    }
    
    ///Funzione che fa il fetch dell'NFT con i dati utente
    func getUserNft(id: String, uId: String, completion: @escaping (NftUserItem?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("nft")
            .document(id)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    completion(nil)
                    return
                }
                
                DispatchQueue.main.async {
                    self?.userNft = NftUserItem(
                        id: data["id"] as? String ?? "",
                        date: data["date"] as? String ?? "",
                        event: data["event"] as? String ?? "",
                        fav: data["fav"] as? Bool ?? false,
                        decision: data["decision"] as? [String] ?? [""]
                    )
                    completion(self?.userNft)
                }
            }
    }
}
