//
//  SearchProductView.swift
//  SwiftUIPractice
//
//  Created by Vadim German on 21.01.2023.
//

import SwiftUI

struct SearchProductView: View {
    let standId: String
    @State private var notFound = false
    @State private var products: [Product] = []
    @State private var isPopupAddVisible = false
    @State private var isPopupCreateVisible = false
    init(standId: String) {
        self.standId = standId
    }
    @State private var barcode: String = ""
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    TextField("Введіть баркод", text: $barcode)
                        .font(.title)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.all, 10).overlay(alignment: .trailing){
                            Image(systemName: "barcode.viewfinder")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10.0).offset(x: -10)
                        }
                    Button(action: searchBarcode) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                    .padding(.all, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .offset(x: -10)
                }
                if(notFound){
                    Spacer()
                    Text("Не знайдено за таким баркодом продукт").font(.title).multilineTextAlignment(.center).padding(.horizontal, 40.0)
                    
                    Button(action: didTapCreateProduct){
                        Text("Створити продукт").font(.title2)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20.0)
                        
                    } .sheet(isPresented: $isPopupCreateVisible) {
                        CreateProductView(product: nil, standId: standId, isPopupCreateVisible: $isPopupCreateVisible, barcode: barcode)
                    }
                }else{
                    List(products, id: \.self) { product in
                        Button(action: didTapSelectProduct) {
                            ProductCardView(product: product)
                        }
                        .sheet(isPresented: $isPopupAddVisible) {
                            PopupView(isPopupAddVisible: self.$isPopupAddVisible, product: product, standId: standId)
                        }
                    }
                }
                Spacer()
                
            }
            
        }
        
    }
    func searchBarcode() {
        guard(!barcode.isEmpty) else {
            products = []
            notFound = false
            return
        };
        FirebaseService.shared.searchDocumentProduct(barcode: barcode) { product in
            guard(product != nil) else {
                products = []
                notFound = true
                return
            };
            products = [product!]
            notFound = false
            print("Has Contact")
            
        }
    }
    
    func didTapSelectProduct() {
        isPopupAddVisible = true
    }
    func didTapCreateProduct() {
        isPopupCreateVisible = true
    }
}


struct SearchProductView_Previews: PreviewProvider {
    static var previews: some View {
        SearchProductView(standId: "4325")
    }
}


struct PopupView: View {
    @Binding var isPopupAddVisible: Bool
    @State var enteredNumber: String = ""
    let product: Product
    let standId: String
    
    var body: some View {
        VStack(alignment: .center) {
            ProductCardView(product: product)
                .padding(.bottom, 20.0)
            Text("Введіть кількість:").font(.title2).multilineTextAlignment(.center)
            HStack {
                TextField("Кількість товару", text: $enteredNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad)
                Button(action: {
                    self.addNumber()
                    self.isPopupAddVisible = false
                }, label: {
                    Text("Додати")
                })
                .padding(.horizontal, 30.0)
                .padding(.vertical, 7.0)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(5)
            }
            
            Spacer()
        }.padding()
        
    }
    
    func addNumber() {
        FirebaseService.shared.setProductToStand(product: product, standId: standId, qty: Int(enteredNumber) ?? 0)
        
    }
}
