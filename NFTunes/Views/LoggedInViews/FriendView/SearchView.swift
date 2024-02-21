//
//  SearchView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 11/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel() //non serve ricrearlo ogni volta che si cambia view
    @StateObject var mainViewModel = MainViewModel()
    @FirestoreQuery var items: [FriendItem]
    @FirestoreQuery var users: [User]
    let userId: String
    @State private var showList = false
    @State private var searchText: String = ""
    
    init(userId: String){
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/friend") //_items is a property wrapper
        self._users = FirestoreQuery(collectionPath: "users")
    }
    
    var body: some View {
        
        ///Funzione di ricerca utente:
        // prendo il nome utente e faccio una ricerca filtrando tra la lista di tutti tranne me stesso
        NavigationStack{
            VStack{
                Form {
                    TextField("Ricerca un nome utente", text: $searchText, onCommit:  {
                        viewModel.username = searchText
                    })
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    
                    if !viewModel.username.isEmpty {
                        List {
                            ForEach(users.filter { $0.id != userId && $0.name.localizedCaseInsensitiveContains(viewModel.username)}) { user in
                                // Cerca l'utente corrispondente nella lista degli amici
                                if let item = items.first(where: { $0.id == user.id }), item.status {
                                    NavigationLink(destination: FriendDetailView(item: user, userId: userId, status: true, userName: mainViewModel.userName, friendItem: item)){
                                        HStack {
                                            VStack(alignment: .leading){
                                                Text(user.name)
                                                    .bold()
                                            }
                                            Spacer()
                                            ImageFormat(size: 50, image: user.image)
                                        }
                                    }
                                } else {
                                    // Controlla se friendRequest è true o false
                                    let friendRequest = items.first(where: { $0.id == user.id })?.friendRequest ?? false
                                    NavigationLink(destination: FriendDetailView(item: user, userId: userId, status: false, userName: mainViewModel.userName, friendItem: .init(id: "", name: "", status: false, friendRequest: friendRequest))){
                                        HStack {
                                            VStack(alignment: .leading){
                                                Text(user.name)
                                            }
                                            Spacer()
                                            ImageFormat(size: 50, image: user.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cerca")
        }
        .onAppear {
            mainViewModel.getUserName(id: userId)
        }
    }
}

#Preview {
    SearchView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
