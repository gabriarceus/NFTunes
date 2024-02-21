//
//  NotificationView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 11/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift
//da implementare la funzione di elimina delle notifiche
struct NotificationView: View {
    @StateObject var viewModel: NotificationViewModel
    @FirestoreQuery var items: [NotificationItem]
    @State private var showAlert = false
    @State private var selectedItem: NotificationItem?
    @StateObject var friendViewModel = FriendViewModel()
    @StateObject var mainViewModel = MainViewModel()
    let userId: String
    
    init(userId: String){
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/notification")
        self._viewModel = StateObject( wrappedValue: NotificationViewModel (userId: userId))
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            //Intestazione
            Text("Notifiche")
                .font(.largeTitle)
                .bold()
                .padding(.top, 50)
            
            Divider()
            
            //Lista delle notifiche
            List(items.sorted { $0.date > $1.date }) { item in
                if item.title.starts(with: "Richiesta") {
                    NotificationItemView(item: item)
                        .onTapGesture {
                            self.selectedItem = item
                            self.showAlert = true
                        }
                        .swipeActions(edge: .trailing){
                            Button {
                                //voglio davvero poter eliminare le notifiche? potrei trattarlo come uno storico?
                                viewModel.delete(id: item.id)
                            } label: {
                                Label("Elimina", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .swipeActions(edge: .leading){
                            Button {
                                //imposta come letto
                                viewModel.setRead(item: item)
                            } label: {
                                if item.read {
                                    Label("Unread", systemImage: "envelope.badge")
                                } else {
                                    Label("Read", systemImage: "envelope.open")
                                }
                            }
                            .tint(.blue)
                        }
                        .alert("Vuoi accettare la richiesta di amicizia di \(item.senderName)?", isPresented: $showAlert) {
                            Button("Accetta", role: .cancel) {
                                friendViewModel.acceptRequest(userId: userId, friendId: item.senderId, userName: mainViewModel.userName)
                                viewModel.delete(id: item.id)
                            }
                            Button("Rifiuta") {
                                friendViewModel.declineRequest(userId: userId, friendId: item.senderId, userName: mainViewModel.userName)
                                viewModel.delete(id: item.id)
                            }
                        }
                } else {
                    NotificationItemView(item: item)
                        .swipeActions(edge: .trailing){
                            Button {
                                //voglio davvero poter eliminare le notifiche? potrei trattarlo come uno storico?
                                viewModel.delete(id: item.id)
                            } label: {
                                Label("Elimina", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .swipeActions(edge: .leading){
                            Button {
                                //imposta come letto
                                viewModel.setRead(item: item)
                            } label: {
                                if item.read {
                                    Label("Unread", systemImage: "envelope.badge")
                                } else {
                                    Label("Read", systemImage: "envelope.open")
                                }
                            }
                            .tint(.blue)
                        }
                }
            }
            .padding(.horizontal, -15)
            .listStyle(PlainListStyle())
            
        }
        .onAppear {
            mainViewModel.getUserName(id: userId)
        }
    }
}

#Preview {
    NotificationView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}

