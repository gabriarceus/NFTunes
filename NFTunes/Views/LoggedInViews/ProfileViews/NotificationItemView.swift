//
//  NotificationItemView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 30/01/24.
//

import SwiftUI

struct NotificationItemView: View {
    let item: NotificationItem
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: !item.read ? "circle.fill" : "")
                .foregroundColor(!item.read ? .accentColor : .primary)
                .padding(!item.read ? 5 : 12)
                .font(.caption)
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text(item.title)
                        .bold()
                    .font(.title3)
                    
                    Spacer()
                    
                    Text("\(Date(timeIntervalSince1970: item.date).formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
                }
                Text(item.description)
                    .font(.callout)
            }
            Spacer()
        }
    }
}

#Preview {
    NotificationItemView(item: .init(id: "n0002", title: "Scambio di NFT", description: "Hai appena effettuato uno scambio col tuo NFT #0001 con NFT #8889 di Paolino Paperino", date: Date().timeIntervalSince1970, read: true, senderId: "RtNpJbt4vfR8O6wUC55GaZkkTf33", senderName: "Paolino Paperino"))
}
