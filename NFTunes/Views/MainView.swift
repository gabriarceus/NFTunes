//
//  ContentView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import SwiftUI


struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State private var selectedTab = 2
    @State private var title = ""
    
    var body: some View {
        NavigationStack {
            if viewModel.isSignedIn, !viewModel.currentUserID.isEmpty {
                //signed in
                accountView
            } else {
                //not signed in
                LoginView()
            }
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ArtistsView(userId: viewModel.currentUserID)
            }
            .tabItem {
                Label("Artisti", systemImage: "music.mic")
            }
            .tag(0)
            
            NavigationView {
                WalletView(userId: viewModel.currentUserID)
            }
            .tabItem {
                Label("Wallet", systemImage: "creditcard")
            }
            .tag(1)
            
            NavigationView {
                ProfileView(userId: viewModel.currentUserID)
            }
            .tabItem {
                Label("Dashboard", systemImage: "music.note.house")
                    .labelStyle(.iconOnly)
            }
            .tag(2)
            
            NavigationView {
                SurveysView(userId: viewModel.currentUserID)
            }
            .tabItem {
                Label("Sondaggi", systemImage: "quote.bubble")
            }
            .tag(3)
            
            NavigationView {
                FriendListView(userId: viewModel.currentUserID)
            }
            .tabItem {
                Label("Amici", systemImage: "person.crop.circle.fill")
            }
            .tag(4)
        }
        .sensoryFeedback(.selection, trigger: selectedTab)
    }
}

#Preview {
    MainView()
}
