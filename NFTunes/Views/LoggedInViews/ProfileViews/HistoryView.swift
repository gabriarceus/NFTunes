//
//  HistoryView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 11/01/24.
//

import SwiftUI

struct HistoryView: View {
    let item: NotificationItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.description)
                    .bold()
                    .font(.footnote)
                Text("\(Date(timeIntervalSince1970: item.date).formatted(date: .long, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            Spacer()
            /*
            Text(item.type)
                .font(.headline)
                .fontWeight(.black)
                .padding(5)
                .background(.pink)
                .clipShape(Circle())
                .foregroundStyle(.white)*/
        }
    }
}

#Preview {
    HistoryView(item: .init(id: "973CE35C-A374-43BD-A5E3-E97864BE9DDE", title: "Scambio effettuato", description: "Hai appena scambiato il tuo NFT#8889 con l'NFT#0001 di Paolino Paperino", date: 1706872790.5716128, read: false,senderId: "RtNpJbt4vfR8O6wUC55GaZkkTf33", senderName: "Paoino Paperino"))
}
