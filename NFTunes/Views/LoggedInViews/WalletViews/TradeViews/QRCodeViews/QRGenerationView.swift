//
//  QRGenerationView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 31/01/24.
//
///Lunghezza massima stringa QR code = 2331

import SwiftUI
import CoreImage.CIFilterBuiltins
import CoreImage

struct QRGenerationView: View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    let tradeId: String
    let userNftId: String
    let friendName: String
    let friendIdNft: String
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Codice QR scambio")
                    .bold()
                    .font(.largeTitle)
                Text("Inquadra il codice QR con la fotocamera del tuo amico per confermare lo scambio")
                    .padding(.horizontal)
                
                Image(uiImage: generateQRCode(from: tradeId)) //from: "(\name)\n\(uId)..."
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                
                Text("Scambio del tuo **NFT #\(friendIdNft)** con l'**NFT #\(userNftId)** di **\(friendName)**")
                    .font(.subheadline)
            }
            .padding()
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    QRGenerationView(tradeId: "186BC036-F6F9-4A11-BA5B-A71FD05CB307", userNftId: "0001" , friendName: "Paolino Paperino", friendIdNft: "8889")
}
