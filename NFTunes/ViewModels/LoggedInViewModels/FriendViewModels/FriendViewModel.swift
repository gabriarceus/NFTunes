//
//  FriendViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 18/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FriendViewModel: ObservableObject {
    init () {}
    
    @Published var friend: FriendItem? = nil
    @Published var nfts: [NftUserItem]? = []
    @Published var user: User? = nil
    
    func getFriend(id: String, friend: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .collection("friend")
            .document(friend)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.friend = FriendItem(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        status: data["status"] as? Bool ?? false,
                        friendRequest: data["friendRequest"] as? Bool ?? false
                    )
                }
            }
    }
    
    func getUser(id: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.user = User(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        joined: data["joined"] as? TimeInterval ?? 0,
                        nfts: data["nfts"] as? Int ?? 0,
                        friends: data["friends"] as? Int ?? 0,
                        events: data["events"] as? Int ?? 0,
                        image: data["image"] as? String ?? "defaultImage"
                    )
                }
            }
    }
    
    func getFriendNfts(id: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .collection("nft")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.nfts = documents.compactMap { document in
                        let data = document.data()
                        return NftUserItem(
                            id: data["id"] as? String ?? "",
                            date: data["name"] as? String ?? "",
                            event: data["event"] as? String ?? "",
                            fav: data["fav"] as? Bool ?? false,
                            decision: data["decision"] as? [String] ?? [""]
                        )
                    }
                }
            }
    }
    
    ///Funzione che rimuove un amico dalla lista amici
    func removeFriend(id: String, friend: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .collection("friend")
            .document(friend)
            .delete()
        
        db.collection("users")
            .document(friend)
            .collection("friend")
            .document(id)
            .delete()
    }
    
    ///Funzione che manda la notifica per la richiesta di amicizia
    func sendRequest(friendId: String, userId: String, userName: String) {
        let newId = UUID().uuidString
        let newItem = NotificationItem(id: newId, title: "Richiesta di amicizia", description: "\(userName) ti ha appena mandato una richiesta di amicizia 😊", date: Date().timeIntervalSince1970, read: false, senderId: userId, senderName: userName)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(friendId)
            .collection("notification")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    ///Funzione che aggiunge un placeholder dopo la richiesta di amicizia (per evitare di mandarne più di una)
    ///friend ma con status a false
    func addPlaceholder(id: String, friend: String, friendName: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .collection("friend")
            .document(friend)
            .setData(["id": friend, "name": friendName, "status": false, "friendRequest": true])
    }
    
    ///Funzione che accetta la richiesta di amicizia
    func acceptRequest(userId: String, friendId: String, userName: String) {
        let db = Firestore.firestore()
        
        let newId = UUID().uuidString
        let newItem = NotificationItem(id: newId, title: "Hai un nuovo amico!", description: "\(userName) ha accettato la tua richiesta di amicizia 😄", date: Date().timeIntervalSince1970, read: false, senderId: userId, senderName: userName)
        
        getUserName(id: friendId) { item in
            if let item = item {
                db.collection("users")
                    .document(userId)
                    .collection("friend")
                    .document(friendId)
                .setData(["id": friendId, "name": item, "status": true, "friendRequest": false])}
        }
        
        db.collection("users")
            .document(friendId)
            .collection("friend")
            .document(userId)
            .setData(["id": userId, "name": userName, "status": true, "friendRequest": false])
        
        db.collection("users")
            .document(friendId)
            .collection("notification")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    ///Funzione che rifiuta la richiesta di amicizia
    func declineRequest(userId: String, friendId: String, userName: String) {
        let db = Firestore.firestore()
        
        let newId = UUID().uuidString
        let newItem = NotificationItem(id: newId, title: "Niente da fare...", description: "\(userName) ha rifiutato la tua richiesta di amicizia 😔", date: Date().timeIntervalSince1970, read: false, senderId: userId, senderName: userName)
        
        db.collection("users")
            .document(friendId)
            .collection("notification")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    ///Funzione che ottiene il nome dell'utente dato il suo id
    func getUserName(id: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    completion(nil)
                    return
                }
                
                DispatchQueue.main.async {
                    let userName = data["name"] as? String
                    completion(userName)
                }
            }
    }
}
