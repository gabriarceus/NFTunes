//
//  ArtistsView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ArtistsView: View {
    @StateObject var viewModel = MainViewModel()
    @FirestoreQuery var items: [ArtistUserItem]
    @State private var showFavoritesOnly = false
    let userId: String
    
    var filteredArtists: [ArtistUserItem] {
        items.filter { item in
            (!showFavoritesOnly || item.fav)
        }
    }
    
    init(userId: String){
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/artist") //_items is a property wrapper
        self.userId = userId
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Toggle(isOn: $showFavoritesOnly) {
                        Text("Solo preferiti")
                            .padding(.vertical, 10)
                    }
                    ForEach(filteredArtists) { item in
                        NavigationLink(destination: ArtistDetailView(item: item, artistId: item.id)){
                            HStack {
                                VStack(alignment: .leading){
                                    Text(item.name)
                                        .bold()
                                }
                                if item.fav {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                                Spacer()
                                ImageFormat(size: 50, image: item.name)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Artisti")
            ///La ricerca ha bisogno o di gestire in modo diverso artisti con cui si ha interagito o no, oppure due viste diverse
            /*.toolbar{
                Button {
                    //pagina di ricerca
                } label: {
                    NavigationLink(destination: ArtistSearchView(userId: userId)){
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 30))
                    }
                }
            }*/
        }
    }
}

#Preview {
    ArtistsView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
