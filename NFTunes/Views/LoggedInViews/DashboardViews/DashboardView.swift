//
//  Dashboard.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

/*
import SwiftUI
import FirebaseFirestoreSwift

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
    @FirestoreQuery var items: [HistoryItem] //property wrapper
    @StateObject var viewMainModel = MainViewModel()
    
    init(userId: String){
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/history") //_items is a property wrapper
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ImageFormat(size: 200, image: "6667")
                    .padding(.top)
                Section {
                    Text("Attività recente")
                        //allinea a sinistra
                        .padding(.top)
                    List(items) {item in
                        HistoryView(item: item)
                    }
                }
                .listStyle(PlainListStyle())
                
                Button {
                    //quando viene premuto mi porta alla pagina del profilo
                    
                } label: {
                    NavigationLink(destination: ProfileView(userId: viewMainModel.currentUserID)){
                        Text("Mostra tutto")
                    }
                }
            }
            .toolbar {
                Button {
                    viewModel.showingSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                }
                Button {
                    viewModel.showingNotification = true
                } label: {
                    Image(systemName: "bell.fill")
                }
            }
            .navigationBarTitle("Dashboard")
            .sheet(isPresented: $viewModel.showingSettings){
                SettingsView()
            }
            .sheet(isPresented: $viewModel.showingNotification) {
                NotificationView(userId: <#T##String#>)
            }
        }
    }
}

#Preview {
    DashboardView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
*/
