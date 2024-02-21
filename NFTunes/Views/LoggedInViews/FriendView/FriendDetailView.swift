//
//  FriendDetailView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 18/01/24.
//
//let _ = print("Quindi è \(friend.status)")

///Funzione di aggiunta amico:
///bool che indica se si è amici o no
///sarebbe da implementare una richiesta di amicizia

import SwiftUI
import FirebaseFirestoreSwift

struct FriendDetailView: View {
    @StateObject var viewModel = FriendViewModel()
    @StateObject var viewDetailModel = MainViewModel()
    let item: User
    let userId: String
    let status: Bool
    @State private var removeFriendAlert = false
    let userName: String
    let friendItem: FriendItem
    @State private var disableButton = false
    @State private var noFriendsAnymore = false
    
    ///if utente -> mainviewModel else friend -> friendviewModel
    var body: some View {
        NavigationStack {
            //if -> siamo amici
            if status && !noFriendsAnymore {
                VStack{
                    if let friendNfts = viewModel.nfts {
                        HStack{
                            VStack {
                                DetailHeaderView(title: item.name, subtitle: "")
                                    .padding(.bottom, -25)
                                NFTButton(title: "Siete amici", background: .blue) {
                                    //Rimuovi amico
                                    removeFriendAlert = true
                                }
                                .alert("Vuoi rimuovere \(item.name) dalla tua lista amici?", isPresented: $removeFriendAlert) {
                                    Button("Rimuovi", role: .destructive) {
                                        viewModel.removeFriend(id: userId, friend: item.id)
                                        noFriendsAnymore = true
                                    }
                                    Button("Annulla", role: .cancel) {}
                                }
                                    .frame(width: 150, height: 75, alignment: .center)
                            }
                            Spacer()
                            ImageFormat(size: 100, image: item.image)
                        }
                        .padding()
                        
                        profile(item: item)
                        
                        ///Lista degli nft che possiede l'amico/utente
                        ScrollView {
                            VStack {
                                ForEach(friendNfts) { nft in
                                    Text("NFT #\(nft.id)")
                                            .bold()
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray)
                                            .cornerRadius(10)
                                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                    }
                                    .padding(.horizontal, 20)
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }
                        Spacer()
                        
                    } else {
                        Text("Loading...")
                            .bold()
                    }
                }
                //else -> se non si è amici
            } else {
                //caso in cui si è mandata la richiesta di amicizia ma non si è ancora amici
                if friendItem.friendRequest || disableButton {
                    VStack {
                        if let friendNfts = viewModel.nfts {
                            HStack{
                                VStack {
                                    DetailHeaderView(title: item.name, subtitle: "")
                                        .padding(.bottom, -25)
                                    NFTButton(title: "Richiesta inviata", background: .gray) {
                                        //Annulla richiesta di amicizia
                                    }
                                    .frame(width: 175, height: 75, alignment: .center)
                                }
                                Spacer()
                                ImageFormat(size: 100, image: item.image)
                            }
                            .padding()
                            
                            profile(item: item)
                            
                            ///Lista degli nft che possiede l'amico/utente
                            ScrollView {
                                VStack {
                                    ForEach(friendNfts) { nft in
                                        Text("NFT #\(nft.id)")
                                            .bold()
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray)
                                            .cornerRadius(10)
                                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                    }
                                    .padding(.horizontal, 20)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            Spacer()
                            
                        }
                    }
                } else if !friendItem.friendRequest || !disableButton {
                    //caso in cui non si è ancora mandata la richiesta di amicizia
                    VStack {
                        if let friendNfts = viewModel.nfts {
                            HStack{
                                VStack {
                                    DetailHeaderView(title: item.name, subtitle: "")
                                        .padding(.bottom, -25)
                                    NFTButton(title: "Non siete amici", background: .gray) {
                                        //Manda richiesta di amicizia
                                        viewModel.sendRequest(friendId: item.id, userId: userId, userName: userName)
                                        //Creo l'oggetto temporaneo amico nella lista amici ma con status = false
                                        viewModel.addPlaceholder(id: userId, friend: item.id, friendName: item.name)
                                        //Disattivo il pulsante per mandare la richiesta
                                        disableButton = true
                                    }
                                    .frame(width: 175, height: 75, alignment: .center)
                                }
                                Spacer()
                                ImageFormat(size: 100, image: item.image)
                            }
                            .padding()
                            
                            profile(item: item)
                            
                            ///Lista degli nft che possiede l'amico/utente
                            ScrollView {
                                VStack {
                                    ForEach(friendNfts) { nft in
                                        Text("NFT #\(nft.id)")
                                            .bold()
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray)
                                            .cornerRadius(10)
                                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                    }
                                    .padding(.horizontal, 20)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            Spacer()
                            
                        }
                    }
                    }
                    else {
                        Text("Loading...")
                            .bold()
                    }
            }
        }
        .onAppear{
            if status{
                viewModel.getFriend(id: userId, friend: item.id) //va bene solo per friend
            } else {
                viewModel.getUser(id: userId) //va bene solo per user
            }
            viewModel.getFriendNfts(id: item.id) //va bene sia per friend che user
        }
    }
    
    ///Vista degli nft amici ed eventi
    @ViewBuilder
    func profile(item: User) -> some View {
        Divider()
        HStack{
            VStack {
                Text("NFTs")
                    .bold()
                Divider()
                Text("\(item.nfts)")
            }
            Divider()
                .frame(height: 70.0)
            VStack {
                Text("Amici")
                    .bold()
                Divider()
                Text("\(item.friends)")
            }
            Divider()
                .frame(height: 70.0)
            VStack {
                Text("Eventi")
                    .bold()
                Divider()
                Text("\(item.events)")
            }
        }
        Divider()
    }
}

#Preview {
    FriendDetailView(item: .init(id: "RtNpJbt4vfR8O6wUC55GaZkkTf33", name: "Daffy Duck", email: "daffy@duck.it", joined: 1705914776.190734, nfts: 0, friends: 0, events: 0, image: "defaultImage"), userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3", status: false, userName: "Pippo Pluto", friendItem: .init(id: "YX8IuaeOSDVdBVAuXkxQvbAnNfI2", name: "Daffy Duck", status: true, friendRequest: true))
}

/// date 10/06/2024 23/06/24 30/05/2024
/// event e006 e007 e001
/// fav true false false
/// id 8889 0011 2345
