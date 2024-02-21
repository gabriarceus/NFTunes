//
//  RegisterView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import SwiftUI
import KeyboardObserving

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        HStack {
            VStack {
                //Header
                HeaderView(title: "Iscriviti",
                           subtitle: "Entra anche tu nel club 😎",
                           angle: -15,
                           background: Color.pink)
            }
        }
        .ignoresSafeArea(.keyboard)
        HStack {
            VStack {
                Form{
                    TextField("Nome", text: $viewModel.name)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                    
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never) //per disattivare l'auto capitalization
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never) //per disattivare l'auto capitalization
                    
                    
                    NFTButton(title: "Crea account", background: .pink) {
                        //Attempt login
                        viewModel.register()
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
            .keyboardObserving()
            //Spacer()
            .frame(minHeight: 500)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    RegisterView()
}
