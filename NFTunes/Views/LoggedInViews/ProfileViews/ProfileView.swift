//
//  ProfileView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @FirestoreQuery var items: [NotificationItem]
    @State private var showingAlert = false
    let userId: String
    @State private var showImagePicker = false
    
    init(userId: String){
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/notification") //_items is a property wrapper
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = viewModel.user {
                    profile(user: user)
                } else {
                    Text("Loading...")
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        viewModel.showingNotification = true
                    } label: {
                        VStack {
                            Image(systemName: "bell.fill")
                                .font(.footnote)
                            Text("Notifiche")
                                .font(.footnote)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .overlay(viewModel.notifications > 0 ? (Badge(count: viewModel.notifications)) : nil)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingAlert = true
                    } label: {
                        VStack {
                            Image(systemName: "door.right.hand.open")
                                .font(.footnote)
                            Text("Log Out")
                                .font(.footnote)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding()
                }
            }
            .alert("Vuoi eseguire il Log Out?", isPresented: $showingAlert){
                Button("Annulla", role: .cancel){}
                Button("Log Out", role: .destructive){viewModel.logout()}
            }
            .sheet(isPresented: $viewModel.showingNotification) {
                NotificationView(userId: userId) //qua potrei mettere dei valori da passare a NotificationView()
            }
            .onOpenURL { url in
                viewModel.handle(url)
            }
            .background(
                Image(viewModel.bgImage)
                //.resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        .init(color: .black, location: 0),
                        .init(color: .clear, location: 0.5)
                    ]), startPoint: .top, endPoint: .bottom))
            )
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
    
    @ViewBuilder
    func profile(user: User) -> some View {
        //Avatar
        ImageFormat(size: 200, image: viewModel.bgImage)
        //premendo sull'immagine si selezione di immagini
        .onTapGesture {
         showImagePicker = true
         }
         .sheet(isPresented: $showImagePicker) {
             ProfileImagePicker(userId: userId, defaultImage: viewModel.bgImage)
         }
        
        
        //Info
        VStack(alignment: .center) {
            HStack {
                Text((user.name))
                    .font(.largeTitle)
                    .bold()
            }
            Text(user.email)
        }
        .padding(.bottom)
        
        Divider()
        HStack{
            VStack {
                Text("NFTs")
                    .bold()
                Divider()
                Text("\(user.nfts)")
            }
            Divider()
                .frame(height: 70.0)
            VStack {
                Text("Amici")
                    .bold()
                Divider()
                Text("\(user.friends)")
            }
            Divider()
                .frame(height: 70.0)
            VStack {
                Text("Eventi")
                    .bold()
                Divider()
                Text("\(user.events)")
            }
        }
        Divider()
        
        VStack {
            Section {
                Text("Attività recente")
                //allinea a sinistra
                    .padding(.top)
                List(items.prefix(3).sorted { $0.date > $1.date }) { item in
                    HistoryView(item: item)
                }
                ///Notifiche non aggiornate in tempo reale
                .onAppear {
                    viewModel.fetchUser()
                    viewModel.notifications = items.filter { !$0.read }.count
                }
                .scrollDisabled(true)
                Text("Per accedere alla cronologia completa apri il centro notifiche")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    ProfileView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
