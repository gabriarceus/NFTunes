//
//  QRScanningView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 31/01/24.
//

import SwiftUI
import CodeScanner

struct QRScanningView: View {
    @State private var isShowingScanner = false
    
    var body: some View {
        NavigationStack{
            Button {
                //Scan QR Code
                isShowingScanner = true
            } label: {
                VStack {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                    Text("Scansiona QR Code")
                        .font(.title2)
                }
                .padding()
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "HEHEHEHA", completion: handleScan)
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        print("Scan successful: \(result)")
        /*
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.people.append(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
            
        }*/
    }
}

#Preview {
    QRScanningView()
}
