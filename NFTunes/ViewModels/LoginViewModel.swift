//
//  LoginViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        //Try to log in
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    
    private func validate() -> Bool {
        //formattazione corretta per i campi
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            errorMessage = "Inserisci i dati in tutti i campi"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Inserisci una mail valida"
            return false
        }
        return true
    }
}
