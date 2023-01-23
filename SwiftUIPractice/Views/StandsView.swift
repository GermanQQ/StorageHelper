//
//  ContentView.swift
//  SwiftUIPractice
//
//  Created by Vadim German on 20.01.2023.
//

import SwiftUI

struct StandsView: View {
    @State private var stands: [Stand] = []
    
    var body: some View {
        NavigationView {
            List(stands) { stand in
                NavigationLink(destination: StandDetailView(stand: stand)) {
                    HStack {
                        Image(systemName: "cube.box").resizable()
                            .foregroundColor(Color.orange)
                            .frame(width: 30.0, height: 30.0)
                        VStack(alignment: .leading) {
                            Text(stand.name)
                                .font(.headline)
                            Text(stand.location)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                        Spacer()
                        Text(stand.filledAndCapacity)
                            .font(.title3)
                    }
                }
            }
            .navigationBarTitle("Стенди")
            .navigationBarItems(trailing:
                                    NavigationLink(destination: CreateStandView()) {Image(systemName: "plus")}
                                
            )
        }.onAppear{
            subscripeToChages()
        }
    }
    
    func subscripeToChages(){
        let docRef = FirebaseService.shared.db.collection(FirebaseService.shared.getStandsPath())
        docRef.addSnapshotListener { snapshot, error in
            guard let data = snapshot?.documents, error == nil else{
                return
            }
            self.stands = data.map { parseDictToStand(data: $0.data()) }
            print("Recived data")
        }
    }
}

struct StandsView_Previews: PreviewProvider {
    static var previews: some View {
        StandsView()
    }
}
