//
//  SurveysDetailedView.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 17/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct SurveysDetailedView: View {
    @StateObject var userViewModel = SurveysUserViewModel()
    @StateObject var viewModel = SurveysViewModel()
    @State var item: SurveyUserItem
    var surveyId: String
    @State private var showingAlertYes = false
    @State private var showingAlertNo = false
    @State private var buttonPressed = false
    @StateObject var mainViewModel = MainViewModel()
    @FirestoreQuery var nfts: [NftUserItem]
    let userId: String
    let timer: Double
    @State private var remainingTime: Double
    
    init(item: SurveyUserItem, surveyId: String, userId: String, timer: Double){
        self.item = item
        self.surveyId = surveyId
        self.userId = userId
        self._nfts = FirestoreQuery(collectionPath: "users/\(userId)/nft") //_items is a property wrapper
        self.timer = timer
        self.remainingTime = timer - Date().timeIntervalSince1970
    }
    
    var timeRemainingString: String {
        let time = Int(remainingTime)
        let days = time / 86400
        let hours = (time % 86400) / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        return String(format: "%02d giorni %02d ore %02d minuti %02d secondi", days, hours, minutes, seconds)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Tempo rimanente")
                        .font(.title)
                        .bold()
                    Text(remainingTime > 0 ? timeRemainingString : "Tempo scaduto")
                        .font(.title3)
                        .foregroundColor(remainingTime > 0 ? .blue : .red)
                        .bold()
                }
            }
            
            if let survey = viewModel.survey {
                HStack {
                    VStack (alignment: .leading){
                        Text("Sondaggio #" + (String(survey.id.dropFirst())))
                            .font(.title)
                            .bold()
                        Text(survey.artist)
                            .font(.title2)
                            .bold()
                        Text(survey.description)
                    }
                    .padding()
                }
                .padding()
                HStack{
                    VStack (alignment: .leading) {
                        Text("Risultato votazioni:")
                        SurveysGraphView(bar1Length: CGFloat(survey.yes), bar2Length: CGFloat(survey.no))
                        Text("Totale voti: " + String(survey.yes + survey.no))
                    }
                    .padding()
                }
                .padding()
                HStack {
                    Text("NFT necessari per votare: ")
                        .bold()
                    ForEach(survey.requirement, id: \.self) { requirement in
                        Text("#\(requirement)")
                            .bold()
                    }
                }
                
                ///Gestione logica di votazione:
                ///se ho già votato OR ho degli nft che sono già stati usati per votare OR non ho tutti gli nft richiesti -->  non posso votare
                ///se ho tutti gli nft richiesti AND non sono già stati usati da qualcun altro per questa votazione AND non ho ancora votato --> posso votare
                HStack {
                    VStack {
                        /// Aggiungere nft che servono per votare -> check se nft che possiedo sono già stati usati o item.joined o buttonPressed
                        /// potrebbe essere un riferimento ad un id specifico oppure un numero
                        if item.joined || buttonPressed {
                            Text("Hai già votato")
                                .bold()
                                .padding()
                        }
                        else if survey.requirement.allSatisfy({ requirement in
                            nfts.contains(where: { $0.id == requirement })
                        }) {
                            //Tutti gli NFT richiesti sono soddisfatti ma alcuni sono già stati usati per votare
                            let usedNfts = nfts.filter { $0.decision.contains(surveyId) && survey.requirement.contains($0.id) }
                            if !usedNfts.isEmpty {
                                let usedNftIds = usedNfts.map { "#\($0.id)" }.joined(separator: "e ")
                                Text("Gli NFT \(usedNftIds) sono già stati usati per votare in questo sondaggio")
                                    .bold()
                                    .padding()
                            } else {
                                let usedNfts = nfts.filter { nft in
                                    survey.requirement.contains(nft.id)
                                }
                                //Tutti gli NFT richiesti sono soddisfatti e non sono stati usati per votare
                                Text("Fai la tua scelta:")
                                HStack {
                                    NFTButton(title: "Si", background: .green) {
                                        showingAlertYes = true
                                    }
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .alert("Confermi di votare Si?", isPresented: $showingAlertYes){
                                        Button("Conferma", role: .cancel){
                                            viewModel.addVote(item: survey, vote: true)
                                            //cambia stato di joined a true
                                            userViewModel.switchToVoted(item: item)
                                            buttonPressed = true
                                            //aggiunta id decisione a NFT
                                            usedNfts.forEach { usedNft in
                                                viewModel.addSurveyId(userId: userId, item: usedNft, surveyId: survey.id)
                                            }
                                        }
                                        Button("Annulla", role: .destructive){}
                                    }
                                    
                                    NFTButton(title: "No", background: .red){
                                        showingAlertNo = true
                                    }
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .alert("Confermi di votare No?", isPresented: $showingAlertNo){
                                        Button("Conferma", role: .cancel){
                                            viewModel.addVote(item: survey, vote: false)
                                            //cambia stato di joined a true
                                            userViewModel.switchToVoted(item: item)
                                            buttonPressed = true
                                            //aggiunta id decisione a NFT
                                            usedNfts.forEach { usedNft in
                                                viewModel.addSurveyId(userId: userId, item: usedNft, surveyId: survey.id)
                                            }
                                        }
                                        Button("Annulla", role: .destructive){}
                                        
                                    }
                                }
                            }
                            
                        } else {
                            //Non possiedo gli NFT richiesti
                            Text("Non possiedi tutti gli NFT necessari per votare")
                                .bold()
                                .padding()
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear{
            viewModel.getSurvey(id: surveyId)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                }
            }
        }
        .background(
            Image("sondaggi")
            //.resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .ignoresSafeArea()
                .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .black, location: 0),
                    .init(color: .clear, location: 0.7)
                ]), startPoint: .top, endPoint: .bottom))
        )
    }
}

#Preview {
    SurveysDetailedView(item: .init(id: "d2468", description: "Vuoi che si organizzi una cena in pizzeria con Anna?", joined: false), surveyId: "d2468", userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3", timer: 1707471000.0)
}
