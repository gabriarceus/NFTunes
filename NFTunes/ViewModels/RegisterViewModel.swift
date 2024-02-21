//
//  RegisterViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var nfts: Int = 0
    @Published var friends: Int = 0
    @Published var events: Int = 0
    @Published var def: String = "defaultImage"
    
    init() {}
    
    func register() {
        guard validate() else {
            return
        }
        //Try to register
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in //weak self per evitare memory leak in caso di chiusura della view prima della fine della registrazione
            guard let userId = result?.user.uid else {
                return
            }
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970, nfts: nfts, friends: friends, events: events, image: def)
        let db = Firestore.firestore()
        db.collection("users").document(id).setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        //formattazione corretta per i campi
        errorMessage = ""
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty, !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            errorMessage = "Inserisci i dati in tutti i campi"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Inserisci una mail valida"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "La password deve contenere almeno 6 caratteri"
            return false
        }
        
        return true
    }
}
