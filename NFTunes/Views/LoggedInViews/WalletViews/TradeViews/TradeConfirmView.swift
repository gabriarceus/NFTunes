//
//  TradeConfirmView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 25/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift
import CoreImage
import CoreImage.CIFilterBuiltins

struct TradeConfirmView: View {
    @StateObject var viewModel = MainViewModel()
    @FirestoreQuery var items: [NftUserItem]
    @State private var showFavoritesOnly = false
    @State private var navigateToTradeView = false
    let userId: String
    @State private var showingAlert = false
    let nftId: String
    let friendName: String
    @State private var selectedItem: NftUserItem? = nil
    @StateObject var tradeViewModel = TradeViewModel()
    let friendId: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var navigateToAnimation = false
    @State private var tradeId: String = ""
    @StateObject var notifViewModel: NotificationViewModel
    
    
    var filteredNfts: [NftUserItem] {
        items.filter { item in
            (!showFavoritesOnly || item.fav)
        }
    }
    
    init(userId: String, nftId: String, friendName: String, friendId: String){
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/nft") //_items is a property wrapper
        self.nftId = nftId
        self.friendName = friendName
        self.friendId = friendId
        self._notifViewModel = StateObject(wrappedValue: NotificationViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Scegli il tuo NFT da scambiare in cambio dell'NFT #\(nftId)")
                    .font(.title3)
                    .bold()
                    .padding(.top, 50)
                    .padding()
                    .multilineTextAlignment(.center)
                
                List {
                    Toggle(isOn: $showFavoritesOnly) {
                        Text("Solo preferiti")
                    }
                    ForEach(filteredNfts) { item in
                        Button {
                            selectedItem = item
                            showingAlert = true
                        } label: {
                            NFTRowView(item: item, tier: 1)
                        }
                        .foregroundColor(.primary)
                        .alert("Confermi lo scambio del tuo NFT #\(selectedItem?.id ?? "") per l'NFT #\(nftId) di \(friendName)?", isPresented: $showingAlert){
                            Button("Conferma", role: .cancel){
                                ///Genero un id univoco per la transazione creando un oggetto di tipo TradingInformation
                                //id: tradeId, date: Date(), id nft user e friend, confirmed: false
                                tradeViewModel.isShowingGeneration = true
                                
                                //Genero l'oggetto trade e mi salvo l'id
                                tradeId = tradeViewModel.generateTradeInfo(userName: userId, offeredNftId: "\(selectedItem?.id ?? "")", requestedNftId: nftId)
                            }
                            Button("Annulla", role: .destructive){
                                //navigateToAnimation = true
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $tradeViewModel.isShowingGeneration) {
                //QR Generated
                QRGenerationView(tradeId: tradeId, userNftId: nftId , friendName: friendName, friendIdNft: "\(selectedItem?.id ?? "")")
                
                    .onAppear {
                        tradeViewModel.startListeningForTradeUpdates(tradeId: tradeId)
                    }
                    .onDisappear {
                        tradeViewModel.stopListeningForTradeUpdates(tradeId: tradeId)
                    }
                    .sheet(isPresented: $navigateToAnimation) {
                        KeyframeAnimationView(userNft: (selectedItem?.id ?? ""), friendNft: nftId)
                    }
            }
            ///Quando confirmed diventa true apre la view di scambio
            .onChange(of: tradeViewModel.isTradeConfirmed) { oldValue, newValue in //come faccio a capire quale è il trade?
                if oldValue == false && newValue == true {
                    navigateToAnimation = true
                    notifViewModel.tradeNotification(userId: userId, offeredNft: (selectedItem?.id ?? ""), receivedNft: nftId, friendId: friendId, friendName: friendName)
                }
            }
            ///Questo onChange quando confirmed diventa true apre la view di scambio
            .onChange(of: navigateToAnimation) { oldValue, newValue in
                if newValue == false {
                    //Ritorna alla view della lista degli NFT dell'utente
                    tradeViewModel.isShowingGeneration = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    TradeConfirmView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3", nftId: "0011", friendName: "Paolino Paperino", friendId: "RtNpJbt4vfR8O6wUC55GaZkkTf33")
}
