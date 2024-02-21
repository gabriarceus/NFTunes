//
//  ProfileImagePicker.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 06/02/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ProfileImagePicker: View {
    @State private var selectedImage = ""
    let userId: String
    let defaultImage: String
    @FirestoreQuery var nfts: [NftUserItem]
    @StateObject var viewModel = ProfileViewModel()
    
    var images: [String] {
        [userId] + ["defaultImage"] + nfts.map { $0.id }
    }
    
    init(userId: String, defaultImage: String) {
        self.userId = userId
        self._nfts = FirestoreQuery(collectionPath: "users/\(userId)/nft")
        self.defaultImage = defaultImage
        self._selectedImage = State(initialValue: defaultImage)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Seleziona un immagine profilo:")
                    .font(.title2)
                    .bold()
                    .padding(.top, 50)
                Spacer()
                ThickDivider()
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { value in
                        HStack(spacing: 10) {
                            ForEach(images, id: \.self) { image in
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .padding()
                                        .id(image)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedImage == image ? Color.red : Color.clear, lineWidth: 5)
                                        )
                                        .onTapGesture {
                                            self.selectedImage = image
                                            value.scrollTo(image, anchor: .center)
                                    }
                                    if image == userId {
                                        Text("ID Utente")}
                                    else if image == "defaultImage" {
                                        Text("Default")
                                    } else {
                                        Text("NFT #\(image)")
                                    }
                                }
                            }
                        }
                        .onAppear {
                            value.scrollTo(selectedImage, anchor: .center)
                        }
                    }
                }
                .padding()
                ThickDivider()
                NFTButton(title: "Salva", background: .blue, action: {viewModel.setImage(userId: userId, image: selectedImage)})
                    .frame(width: 200, height: 75)
                    .padding()
                
                .padding(.bottom, 150)
            }
            .background(
                Image(selectedImage)
                //.resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        .init(color: .black, location: 0),
                        .init(color: .clear, location: 0.8)
                    ]), startPoint: .top, endPoint: .bottom))
            )
        }
    }
}

#Preview {
    ProfileImagePicker(userId: "RtNpJbt4vfR8O6wUC55GaZkkTf33", defaultImage: "RtNpJbt4vfR8O6wUC55GaZkkTf33")
}
