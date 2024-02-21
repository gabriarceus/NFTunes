//
//  LoginView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import SwiftUI
import KeyboardObserving

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    //@StateObject var keyboard = Keyboard()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack{
                        //Header
                        HeaderView(title: "NFTunes", subtitle: "La prima app per NFT di artisti", angle: 15, background: Color.blue)
                    }
                }
                .ignoresSafeArea(.keyboard)
                //Login Form
                HStack {
                    VStack {
                        Form {
                            //Error Message for login
                            if !viewModel.errorMessage.isEmpty {
                                Text(viewModel.errorMessage)
                                    .foregroundColor(.red)
                            }
                            
                            TextField("Email", text: $viewModel.email)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never) //per disattivare l'auto capitalization
                            
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never) //per disattivare l'auto capitalization
                            
                            NFTButton(title: "Accedi", background: .blue) {
                                viewModel.login()
                            }
                        }
                        .ignoresSafeArea(.keyboard)
                        .offset(y: -50)
                        .keyboardObserving()
                    }
                    //faccio in modo che quando apro la tastiera il form si sposta verso l'alto
                    .ignoresSafeArea(.keyboard)
                }
                
                //Create Account
                HStack {
                    VStack {
                        Text("Non hai un account?")
                        NavigationLink("Iscriviti", destination: RegisterView())
                    }
                    .ignoresSafeArea(.keyboard, edges: .all)
                .padding(.top, -30)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
