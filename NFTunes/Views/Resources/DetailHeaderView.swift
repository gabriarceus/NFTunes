//
//  DetailHeaderView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 12/01/24.
//

import SwiftUI

struct DetailHeaderView: View {
    @StateObject var viewModel = NftUserViewModel()
    
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .bold()
                    //.dynamicTypeSize(.xxxLarge)
                    .font(.system(size: 25)) ///Si potrebbe mettere come variabile
                    .minimumScaleFactor(0.01)
                Text(subtitle)
            }
        }
    }
}

#Preview {
    DetailHeaderView(title: "Title", subtitle: "Subtitle")
}
