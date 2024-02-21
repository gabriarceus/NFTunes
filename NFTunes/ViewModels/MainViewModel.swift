//
//  MainViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation
import FirebaseAuth
import Firebase

class MainViewModel: ObservableObject {
    @Published var currentUserID: String = ""
    @Published var userName: String = ""
    private var handler: AuthStateDidChangeListenerHandle? //di default è nil
    
    private var db = Firestore.firestore()
    
    init(){
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in //per evitare memory leak
            self?.currentUserID = user?.uid ?? ""
            DispatchQueue.main.async {
                self?.currentUserID = user?.uid ?? "" //aggiorna la main queue
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    ///Funzione che ottiene il nome dell'utente dato il suo id
    func getUserName(id: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.userName = data["name"] as? String ?? ""
                }
            }
    }
}
