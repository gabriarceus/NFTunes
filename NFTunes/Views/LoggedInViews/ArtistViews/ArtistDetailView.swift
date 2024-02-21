//
//  ArtistDetailView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 16/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ArtistDetailView: View {
    @StateObject var userViewModel = ArtistUserViewModel()
    @StateObject var viewModel = ArtistViewModel()
    let item: ArtistUserItem
    let artistId: String
    
    var body: some View {
        
        VStack {
            if let artist = viewModel.artist {
                HStack {
                    Text(artist.name)
                        .bold()
                        .font(.title)
                    Button{
                        userViewModel.toggleIsFav(item: item)
                    } label: {
                        Label("Toggle Favorite", systemImage: item.fav ? "star.fill" : "star")
                            .labelStyle(.iconOnly)
                            .foregroundColor(item.fav ? .yellow : .gray)
                            .dynamicTypeSize(.xxxLarge)
                    }
                    Spacer()
                    ImageFormat(size: 150, image: artist.name)
                }
                .padding()
                
                HStack {
                    Text(artist.description)
                        .dynamicTypeSize(.xLarge)
                }
                .padding()
                Section(header: Text("Eventi nei quali ha performato: ")) {
                    ScrollView {
                        VStack {
                            ForEach(artist.event, id: \.self) { event in
                                NavigationLink(destination: EventView(eventId: event)){
                                    Text("Evento #\(String(event.dropFirst()))")
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
                    }
                    //.background(Color.clear)
                }
                .padding(.top, 30)
            }
            Spacer()
        }
        .onAppear{
            viewModel.getArtist(id: artistId)
        }
        .background(
            Image(item.name)
            //.resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .ignoresSafeArea()
                .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .black, location: 0),
                    .init(color: .clear, location: 0.7)
                ]), startPoint: .top, endPoint: .bottom))
        )
    }
}

#Preview {
    ArtistDetailView(item: .init(id: "a10", name: "Maneskin", fav: false), artistId: "a10")
}
