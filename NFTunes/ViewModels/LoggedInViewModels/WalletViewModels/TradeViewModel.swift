//
//  TradeViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 25/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import CodeScanner
import FirebaseDatabaseInternal

class TradeViewModel: ObservableObject {
    init() {}
    
    @Published var nft: NftUserItem? = nil
    @Published var isShowingScanner: Bool = false
    @Published var isShowingGeneration: Bool = false
    @Published var trade: TradingInformation? = nil
    @Published var lastScanResult: String = ""
    @Published var isShowingAlert: Bool = false
    @Published var isShowingError: Bool = false
    @Published var tradeId: String = ""
    @Published var isTradeConfirmed: Bool = false
    @Published var user: User? = nil
    @Published var nftUser: NftUserItem? = nil
    
    ///Funzione che permette lo scambio di due nft
    ///precondizione: userId, userNft.id -- friendId, friendNft.id
    ///postcondizione: userId, friendNft.id -- fritndId, userNft.id
    func swapNft(userId: String, userNftId: String, friendId: String, friendNftId: String){
        let db = Firestore.firestore()
        
        // Inizia una nuova transazione
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let userNftDocument: DocumentSnapshot
            let friendNftDocument: DocumentSnapshot
            
            do {
                try userNftDocument = transaction.getDocument(db.collection("users").document(userId).collection("nft").document(userNftId))
                try friendNftDocument = transaction.getDocument(db.collection("users").document(friendId).collection("nft").document(friendNftId))
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let userNftData = userNftDocument.data(), let friendNftData = friendNftDocument.data() else {
                let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Unable to retrieve NFT from snapshot \(userNftDocument)"
                ])
                errorPointer?.pointee = error
                return nil
            }
            
            // Imposta i nuovi dati
            transaction.setData(userNftData, forDocument: db.collection("users").document(friendId).collection("nft").document(userNftId))
            transaction.setData(friendNftData, forDocument: db.collection("users").document(userId).collection("nft").document(friendNftId))
            
            // Elimina i vecchi dati
            transaction.deleteDocument(db.collection("users").document(userId).collection("nft").document(userNftId))
            transaction.deleteDocument(db.collection("users").document(friendId).collection("nft").document(friendNftId))
            
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
    
    ///Funzione che legge il QR code
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let tradeId = result.string
            print("Scan successful: \(tradeId)")
            
            ///Uso il tradeId per fare un fetch dell'item nel database
            lastScanResult = tradeId
            getTradeInfo(id: tradeId)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.trade != nil {
                    self.isShowingAlert = true
                } else {
                    self.isShowingError = true
                }
            }
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
            
            lastScanResult = ""
        }
    }
    
    ///Funzione che fa il fetch dell'oggetto con id tradeId
    func getTradeInfo(id: String){
        let db = Firestore.firestore()
        db.collection("trades")
            .document(id)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.trade = TradingInformation(
                        id: data["id"] as? String ?? "",
                        date: data["date"] as? Double ?? 0,
                        userName: data["userName"] as? String ?? "",
                        offeredNftId: data["offeredNftId"] as? String ?? "",
                        requestedNftId: data["requestedNftId"] as? String ?? "",
                        confirmed: data["confirmed"] as? Bool ?? false
                    )
                }
            }
    }
    
    ///Creo l'oggetto trade nel database
    ///contiene anche gli nft che voglio scambiare e il nome della persona che li vuole scambiare
    func generateTradeInfo(userName: String, offeredNftId: String, requestedNftId: String) -> String {
        //guard let uId = Auth.auth().currentUser?.uid else {return}
        
        let newId = UUID().uuidString
        let newItem = TradingInformation(id: newId, date: Date().timeIntervalSince1970, userName: userName, offeredNftId: offeredNftId, requestedNftId: requestedNftId, confirmed: false)
        
        let db = Firestore.firestore()
        db.collection("trades")
            .document(newId)
            .setData(newItem.asDictionary())
        
        //mi serve sapere qual'è l'id del trade da passare agli altri
        let trade = newItem.id
        //tradeId = trade //anche questo
        //getTradeInfo(id: trade) questo genera trade a raffica
        return trade
    }
    
    ///Funzione che genera una stringa alfanumerica random
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    ///Funzione che cambia lo stato di confirmed a true
    func tradeConfirmed(item: TradingInformation){
        var itemCopy = item
        itemCopy.confirmed = true
        
        let db = Firestore.firestore()
        db.collection("trades")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary(), merge: true)
    }
    
    ///Funzione che fa un polling al database per controllare se ci sono cambiamenti nel trade
    func startListeningForTradeUpdates(tradeId: String) {
        let db = Firestore.firestore()
        db.collection("trades")
            .document(tradeId)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {return}
                guard let data = snapshot.data() else {return}
                
                if let confirmed = data["confirmed"] as? Bool {
                    self.isTradeConfirmed = confirmed
                }
            }
    }
    
    ///Funzione che smette di fare il polling
    func stopListeningForTradeUpdates(tradeId: String) {
        let tradeRef = Database.database().reference(withPath: "trades/\(tradeId)")
        tradeRef.removeAllObservers()
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
    
    ///Dopo lo scambio resetto il campo isFav a false
    func resetIsFav(item: NftUserItem, uId: String) {
        var newItem = item
        print(newItem)
        newItem.setFav(false)
        print(newItem)
        
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("nft")
            .document(newItem.id)
            .setData(newItem.asDictionary(), merge: true)
    }
    
}
