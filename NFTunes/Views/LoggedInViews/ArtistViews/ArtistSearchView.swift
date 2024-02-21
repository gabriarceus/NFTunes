//
//  ArtistsSearchView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 18/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ArtistSearchView: View {
    @StateObject var viewModel = ArtistSearchViewModel()
    @StateObject var mainViewModel = MainViewModel()
    @FirestoreQuery var items: [ArtistUserItem]
    @FirestoreQuery var artists: [ArtistItem]
    let userId: String
    @State private var showList = false
    
    init(userId: String){
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/artist") //_items is a property wrapper
        self._artists = FirestoreQuery(collectionPath: "artists")
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Form {
                    TextField("Ricerca un nome utente", text: $viewModel.artist)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    /*
                    if !viewModel.artist.isEmpty{
                        List {
                            ForEach(items) { item in
                                ForEach((artists.filter { $0.id != userId  && $0.name.localizedCaseInsensitiveContains(viewModel.artist)})) {artist in
                                    //il friendId dovrebbe essere quello dell'utente
                                    if item.fav && item.id == artist.id {
                                        NavigationLink(destination: ArtistDetailView(item: item, userId: userId, status: true)){
                                            HStack {
                                                VStack(alignment: .leading){
                                                    Text(artist.name)
                                                        .bold()
                                                }
                                                Spacer()
                                                ImageFormat(size: 50, image: "Shiva")
                                            }
                                        }
                                    } else {
                                        NavigationLink(destination: ArtistDetailView(item: item, userId: userId, status: false)){
                                            HStack {
                                                VStack(alignment: .leading){
                                                    Text(artist.name)
                                                    //.bold()
                                                }
                                                Spacer()
                                                ImageFormat(size: 50, image: "Shiva")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }*/
                }
            }
            .navigationTitle("Cerca")
        }
    }
}

#Preview {
    ArtistSearchView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
