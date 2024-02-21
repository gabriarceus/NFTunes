//
//  NotificationViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 11/01/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class NotificationViewModel: ObservableObject {
    
    private let userId: String
    
    init(userId: String){
        self.userId = userId
    }
    
    //var dataAttuale = Date()
    
    ///Funzione che elimina una notifica dal database
    func delete(id: String){
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("notification")
            .document(id)
            .delete()
    }
    
    ///Funzione che permette di segnare una notifica come letta
    //Sovrascrivendo il dato permette di aggiornare la vista in tempo reale
    func setRead(item: NotificationItem) {
        var itemCopy = item
        itemCopy.setRead(!item.read)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("notification")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
    
    ///Funzione che dopo uno scambio inserisce una notifica nel database
    func tradeNotification(userId: String, offeredNft: String, receivedNft: String, friendId: String, friendName: String){
        let newId = UUID().uuidString
        let newItem = NotificationItem(id: newId, title: "Scambio effettuato", description: "Hai appena scambiato il tuo NFT#\(offeredNft) con l'NFT#\(receivedNft) di \(friendName) 🤑", date: Date().timeIntervalSince1970, read: false, senderId: friendId, senderName: friendName)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("notification")
            .document(newId)
            .setData(newItem.asDictionary())
        
    }
    
    
}
