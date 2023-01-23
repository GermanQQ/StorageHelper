//
//  StandDetailView.swift
//  SwiftUIPractice
//
//  Created by Vadim German on 20.01.2023.
//

import SwiftUI

struct StandDetailView: View {
    @State var stand: Stand
    @State private var isBuzy: Bool
    @State private var products: [Product]
    
    init(stand: Stand, isBuzy: Bool = true, products: [Product] = []) {
        self.stand = stand
        self.isBuzy = isBuzy
        self.products = products
    }
    
    var body: some View {
        NavigationView{
            if(isBuzy){
                ActivityIndicator(isAnimating: $isBuzy, style: .medium)
            }else if(products.isEmpty){
                Text("На цьому стендів нема продуктів, щоб дадати їх натисніть +").font(.title2).multilineTextAlignment(.center).padding(.horizontal, 40.0).foregroundColor(.gray)
            }else{
                List(products, id: \.self) { product in
                    ProductCardView(product: product)
                }
            }
        }.onAppear{
            subscripeToChanges()
        }
        
        .navigationBarTitle(stand.name)
        .navigationBarItems(trailing:
                                NavigationLink(destination: SearchProductView(standId: stand.id)) {Image(systemName: "plus")})
        
    }
    
    func subscripeToChanges(){
        let docRef = FirebaseService.shared.db.collection(FirebaseService.shared.getStandsPath()).document(stand.id)
        docRef.addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            stand = parseDictToStand(data: data)
            updateProducts()
        }
    }
    
    private func updateProducts() {
        FirebaseService.shared.getProductsByStand(stand: stand) { products in
            isBuzy = false
            self.products = products
            print("Received data: updateProducts ")
        }
    }
}

struct StandDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StandDetailView(stand: Stand(name: "Text", location: "G8", capacity: 50))
    }
}



