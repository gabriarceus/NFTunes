//
//  TradeChoiceNftView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 23/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

///Qua dovrebbe vedersi l'utente con gli nft che possiede
final class SheetIsPresented: ObservableObject {
    static let shared = SheetIsPresented()
    @Published var value: Bool = false
    @Published var selectedNft: NftItem? = nil
}

struct TradeChoiceNftView: View {
    @StateObject var viewModel = MainViewModel()
    @FirestoreQuery var items: [NftUserItem]
    @FirestoreQuery var nfts: [NftItem]
    let friendId: String
    let friend: String
    let userId: String
    @ObservedObject var sheetIsPresented = SheetIsPresented.shared
    
    init(friendId: String, friend: String, userId: String){
        self.userId = userId
        self.friend = friend
        self.friendId = friendId
        self._items = FirestoreQuery(collectionPath: "users/\(friendId)/nft")
        self._nfts = FirestoreQuery(collectionPath: "nfts")
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Scegli un NFT da scambiare")
                    .font(.title3)
                    .bold()
                    .padding()
                List {
                    Text("NFT che \(friend) possiede:")
                    ForEach(items) { item in
                        ForEach((nfts.filter {$0.id == item.id})) { nft in
                            HStack {
                                VStack(alignment: .leading){
                                    Text("NFT #" + nft.id)
                                        .bold()
                                    Text("Artista: **\(nft.artist)**")
                                    Text("NFT di tier: **\(nft.tier)**")
                                }
                                Spacer()
                                
                                NftImageFormat(size: 50, image: item.id, tier: nft.tier)
                            }
                            .padding(.horizontal)
                            .foregroundColor(.primary)
                            .onTapGesture {
                                sheetIsPresented.selectedNft = nft
                                sheetIsPresented.value = true
                            }
                        }
                    }
                }
                .sheet(isPresented: $sheetIsPresented.value) {
                    if let nft = sheetIsPresented.selectedNft {
                        TradeConfirmView(userId: userId, nftId: nft.id, friendName: friend, friendId: friendId)
                    }
                }
                .navigationTitle(friend)
            }
        }
    }
}
#Preview {
    TradeChoiceNftView(friendId: "RtNpJbt4vfR8O6wUC55GaZkkTf33", friend: "Paolino Paperino", userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
