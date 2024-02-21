//
//  ProfileViewModel.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

//Qua posso mettere i dati della notifica quando la chiamo
struct NotificationData {
    let description: String
}

class ProfileViewModel: ObservableObject {
    @Published var showingNotification = false
    @Published var user: User? = nil
    @Published var notifications = 0
    private var listener: ListenerRegistration?
    @Published var bgImage = ""
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
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
        fetchNotifications(userId: userId)
        fetchImage(userId: userId)
    }
    
    ///Funzione che, grazie ad un listener, recupera le notifiche in tempo reale
    func fetchNotifications(userId: String) {
        let db = Firestore.firestore()
        listener = db.collection("users").document(userId).collection("notification")
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let documents = snapshot?.documents, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let items = documents.compactMap { try? $0.data(as: NotificationItem.self) }
                    self?.notifications = items.filter { !$0.read }.count
                }
            }
    }
    
    /// Rimuove il listener quando il ViewModel viene deallocato
    deinit {
        listener?.remove()
    }
    
    ///Funzione che fa il fetch dell'immagine profilo
    func fetchImage(userId: String) {
        let db = Firestore.firestore()
        listener = db.collection("users").document(userId)
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.bgImage = data["image"] as? String ?? "defaultImage"
                }
            }
    }
    
    ///Funzione che imposta l'immagine profilo selezionata
    func setImage(userId: String, image: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData(["image": image])
    }
    
    
    func logout(){
        do{
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    //apre la vista notifiche
    func handle(_ url: URL) {
        if url.host() == "notification" {
            showingNotification = true
        }
    }
    
}

//per passare dei dati ad una view con un link
extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value?.replacingOccurrences(of: "+", with: " ")
        }
    }
}
