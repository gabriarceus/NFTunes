//
//  FriendListView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 18/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct FriendListView: View {
    @StateObject var viewModel = MainViewModel()
    @FirestoreQuery var items: [FriendItem]
    @FirestoreQuery var users: [User]
    let userId: String
    
    init(userId: String){
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/friend") //_items is a property wrapper
        self._users = FirestoreQuery(collectionPath: "users")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(items) { item in
                        ForEach((users.filter { $0.id != userId})) {user in
                            if item.status && user.id == item.id {//item dovrebbe essere il friend, il friendId dovrebbe essere quello dell'utente
                                NavigationLink(destination: FriendDetailView(item: user, userId: userId, status: true, userName: viewModel.userName, friendItem: item)){
                                    HStack {
                                        VStack(alignment: .leading){
                                            Text(user.name)
                                                .bold()
                                        }
                                        Spacer()
                                        ImageFormat(size: 50, image: user.id)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top)
                .navigationTitle("Amici")
                .toolbar{
                    Button {
                        //pagina di ricerca
                    } label: {
                        NavigationLink(destination: SearchView(userId: userId)){
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.system(size: 30))
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .onAppear {
            viewModel.getUserName(id: userId)
        }
    }
}

#Preview {
    FriendListView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
