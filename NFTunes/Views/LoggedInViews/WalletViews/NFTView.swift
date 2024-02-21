//
//  NFTView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 12/01/24.
//let _ = print(nftId)

import SwiftUI
import FirebaseFirestoreSwift

//ora prendo i dati che ho ricevuto in ingresso da NFTView
struct NFTView: View {
    @StateObject var userViewModel = NftUserViewModel()
    @StateObject var viewModel = NftViewModel()
    let item: NftUserItem
    let nftId: String
    
    var body: some View {
        VStack{
            HStack {
                DetailHeaderView(title: ("NFT #" + item.id), subtitle: item.date)
                
                Button{
                    userViewModel.toggleIsFav(item: item)
                } label: {
                    Label("Toggle Favorite", systemImage: item.fav ? "star.fill" : "star")
                        .labelStyle(.iconOnly)
                        .foregroundColor(item.fav ? .yellow : .gray)
                        .dynamicTypeSize(.xxxLarge)
                }
                
                Spacer()
                if let nft = viewModel.nft {
                    NftImageFormat(size: 100, image: item.id, tier: nft.tier)
                }
            }
            .padding()
            if let nft = viewModel.nft {
                HStack {
                    Text("Quantità: \(nft.amount)")
                        .bold()
                }
                HStack {
                    Text("Artista: \(nft.artist)")
                        .bold()
                }
            }
            if let nft = viewModel.nft {
                HStack {
                    NFTGraphView(volume: nft.volume)
                }
            }
            VStack{
                Text("Ottenibile da:")
                Button {
                    //quando viene premuto mi porta alla pagina dell'evento
                    
                } label: {
                    NavigationLink(destination: EventView(eventId: item.event)){
                        Text("Evento dal vivo")
                            .bold()
                            .padding()
                    }
                }
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .bold()
                .foregroundColor(.white)
                Text("In data:")
                Text(item.date)
                    .bold()
            }
        }
        .background(
            Image(item.id)
            //.resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .ignoresSafeArea()
                .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .black, location: 0),
                    .init(color: .clear, location: 0.7)
                ]), startPoint: .top, endPoint: .bottom))
        )
        .onAppear{
            viewModel.getNft(id: nftId)
        }
    }
}

#Preview {
    NFTView(item: .init(id: "1234", date: "12/01/2024", event:"e001", fav: true, decision: [""]), nftId:"1234")
}
