//
//  EventView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 16/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct EventView: View {
    @StateObject var viewModel = EventViewModel()
    let eventId: String
    
    
    var body: some View {
        NavigationStack {
            VStack{
                if let event = viewModel.event {
                    HStack{
                        DetailHeaderView(title: event.name, subtitle: event.date)
                        ImageFormat(size: 100, image: "concerto")
                    }
                    .padding(.bottom, 20)
                    Text(event.description)
                        .padding(.bottom, 150)
                    Section(header: Text("NFT ottenibili")) {
                        ScrollView {
                            VStack {
                                Text("NFT #\(event.tier1)")
                                    .bold()
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                Text("NFT #\(event.tier2)")
                                    .bold()
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                Text("NFT #\(event.tier3)")
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
                } else {
                    Text("Loading...")
                        .bold()
                }
            }
            .background(
                Image("concerto")
                //.resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        .init(color: .black, location: 0),
                        .init(color: .clear, location: 0.9)
                    ]), startPoint: .top, endPoint: .bottom))
            )
        }
        .onAppear{
            viewModel.getEvent(id: eventId)
        }
    }
}

#Preview {
    EventView(eventId: "e004")
}
