//
//  WalletView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct WalletView: View {
    @StateObject var viewModel = MainViewModel()
    @FirestoreQuery var items: [NftUserItem]
    @State private var showFavoritesOnly = false
    @State private var navigateToTradeView = false
    let userId: String
    
    var filteredNfts: [NftUserItem] {
        items.filter { item in
            (!showFavoritesOnly || item.fav)
        }
    }
    
    
    init(userId: String){
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/nft") //_items is a property wrapper
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Section {
                    NFTButton(title: "Scambia NFT", background: .blue) {
                        self.navigateToTradeView = true
                    }
                    .frame(width: 170, height: 80, alignment: .center)
                    .navigationDestination(
                        isPresented: $navigateToTradeView) {
                            TradeView(userId: userId)
                        }
                        //.frame(width: 170, height: 80, alignment: .center)
                        //.padding(.top)
                    
                    List {
                        Toggle(isOn: $showFavoritesOnly) {
                            Text("Solo preferiti")
                        }
                        .padding(3)
                        ForEach(filteredNfts) { item in
                            NavigationLink(destination: NFTView(item: item, nftId: item.id)){
                                NFTRowView(item: item, tier: 1)
                            }
                        }
                    }
                    .padding(.top, -20)
                }
            }
            .animation(Animation.easeInOut, value: showFavoritesOnly)
            .navigationTitle("Wallet")
        }
    }
}

#Preview {
    WalletView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
