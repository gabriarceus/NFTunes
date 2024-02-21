//
//  TradeView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 23/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift
import CodeScanner

struct TradeView: View {
    @StateObject var viewModel = MainViewModel()
    @FirestoreQuery var items: [FriendItem]
    @FirestoreQuery var users: [User]
    let userId: String
    @StateObject var tradeViewModel = TradeViewModel()
    @State private var navigateToAnimation = false
    @StateObject var notifViewModel: NotificationViewModel
    @StateObject var nftViewModel = NftViewModel()
    @State private var reqNftId: String = ""
    @State private var offerNftId: String = ""
    
    init(userId: String){
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/friend") //_items is a property wrapper
        self._users = FirestoreQuery(collectionPath: "users")
        self._notifViewModel = StateObject(wrappedValue: NotificationViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(items) { item in
                        ForEach((users.filter { $0.id != userId})) {user in
                            if item.status && user.id == item.id {//item dovrebbe essere il friend, il friendId dovrebbe essere quello dell'utente
                                NavigationLink(destination: TradeChoiceNftView(friendId: user.id, friend: user.name, userId: userId)){
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
                .navigationTitle("Scambio")
                .toolbar{
                    Button {
                        //scan QR code
                        tradeViewModel.isShowingScanner = true
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 30))
                    }
                    .sheet(isPresented: $tradeViewModel.isShowingScanner) {
                        //L'output di questa view è l'id del trade in corso
                        //faccio un fetch delle info del trade e le mostro sotto forma di prompt
                        //se conferma inizia lo scambio, se rifiuta rimane su false e non succede nulla
                        CodeScannerView(codeTypes: [.qr], simulatedData: "255F1FF5-7324-42DC-9ACC-E2C2201EFEE2", completion: tradeViewModel.handleScan)
                    }
                    .alert("Informazioni sullo scambio", isPresented: $tradeViewModel.isShowingAlert){
                        Button("Conferma", role: .cancel){
                            // Viene impostato il valore di confirmed a true, inizia l'animazione di scambio e viene scambiato l'NFT
                            if let trade = tradeViewModel.trade {
                                tradeViewModel.tradeConfirmed(item: trade)
                                
                                //Viene mostrata l'animazione di scambio
                                navigateToAnimation = true
                                
                                //Viene effettuato lo scambio
                                tradeViewModel.swapNft(userId: tradeViewModel.trade?.userName ?? "", userNftId: tradeViewModel.trade?.offeredNftId ?? "", friendId: userId, friendNftId: tradeViewModel.trade?.requestedNftId ?? "")
                                
                                //Viene creata la notifica di scambio
                                tradeViewModel.getUserName(id: tradeViewModel.trade?.userName ?? "") { userName in
                                    if let userName = userName {
                                        notifViewModel.tradeNotification(userId: userId, offeredNft: tradeViewModel.trade?.requestedNftId ?? "", receivedNft: tradeViewModel.trade?.offeredNftId ?? "", friendId: tradeViewModel.trade?.userName ?? "", friendName: userName )
                                    }
                                }
                                    reqNftId = tradeViewModel.trade?.requestedNftId ?? ""
                                    offerNftId = tradeViewModel.trade?.offeredNftId ?? ""
                            }
                        }
                        Button("Annulla", role: .destructive){
                            // Viene annullata l'operazione. L'altro utente deve uscire dalla schermata del QR
                        }
                    } message: {
                        Text("Confermi lo scambio del tuo NFT#\(tradeViewModel.trade?.requestedNftId ?? "") in cambio dell'NFT#\(tradeViewModel.trade?.offeredNftId ?? "") del tuo amico?")
                    }
                    
                    .alert("Errore", isPresented: $tradeViewModel.isShowingError){
                        Button("OK", role: .cancel){}
                    } message : {
                        Text("Qualcosa è andato storto!\nNon è stato possibile recuperare le informazioni sullo scambio")
                    }
                }
            }
            .sheet(isPresented: $navigateToAnimation) {
                KeyframeAnimationView(userNft: tradeViewModel.trade?.requestedNftId ?? "", friendNft: tradeViewModel.trade?.offeredNftId ?? "")
            }
            .onChange(of: navigateToAnimation) { oldValue, newValue in
                if newValue == false {
                    //Viene resettato il campo isFav degli NFT scambiati (uso un completion handler)
                    nftViewModel.getUserNft(id: offerNftId, uId: userId) { nft in
                        print(offerNftId)
                        if let nft = nft {
                            tradeViewModel.resetIsFav(item: nft, uId: userId)
                        }
                    }
                    
                    nftViewModel.getUserNft(id: reqNftId, uId: tradeViewModel.trade?.userName ?? "") { nft in
                        print(reqNftId)
                        if let nft = nft {
                            tradeViewModel.resetIsFav(item: nft, uId: tradeViewModel.trade?.userName ?? "")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TradeView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
/*
 
 //Viene resettato il campo isFav degli NFT scambiati (uso un completion handler)
 //in questo momento crea un nuovo oggetto senza attributi
 nftViewModel.getUserNft(id: tradeViewModel.trade?.requestedNftId ?? "") { nft in
 if let nft = nft {
 tradeViewModel.resetIsFav(item: nft, uId: userId)
 }
 }
 
 nftViewModel.getUserNft(id: tradeViewModel.trade?.offeredNftId ?? "") { nft in
 if let nft = nft {
 tradeViewModel.resetIsFav(item: nft, uId: tradeViewModel.trade?.userName ?? "")
 }
 }
 
 */
