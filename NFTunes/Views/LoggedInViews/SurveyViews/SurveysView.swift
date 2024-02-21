//
//  Surveys.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct SurveysView: View {
    @StateObject var viewModel = MainViewModel()
    @FirestoreQuery var items: [SurveyUserItem]
    @State private var showJoinedOnly = true
    let userId:String
    @FirestoreQuery var surveys: [SurveyItem]
    
    var filteredSurveys: [SurveyUserItem] {
        items.filter { item in
            showJoinedOnly ? item.joined : !item.joined
        }
    }
    
    init(userId: String){
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/decision") //_items is a property wrapper
        self._surveys = FirestoreQuery(collectionPath: "decisions")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Picker(selection: $showJoinedOnly, label: Text("Filtro")) {
                        Text("Partecipante").tag(true)
                        Text("Non Partecipante").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    ForEach(filteredSurveys) { item in
                        ForEach(surveys) {survey in
                            if item.id == survey.id {
                                NavigationLink(destination: SurveysDetailedView(item: item, surveyId: item.id, userId: userId, timer: survey.timer)){
                                    HStack {
                                        VStack(alignment: .leading){
                                            Text("Sondaggio  #" + String(item.id.dropFirst()))
                                                .font(.headline)
                                            Text(item.description)
                                                .font(.subheadline)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Sondaggi")
        }
    }
}

#Preview {
    SurveysView(userId: "yL6IwvLTY3NmESKnyMhBYFgWiGD3")
}
