//
//  StandDetailView.swift
//  SwiftUIPractice
//
//  Created by Vadim German on 20.01.2023.
//

import SwiftUI

struct CreateStandView: View {
    
    @State private var name: String = ""
    @State private var capacity: String = ""
    @State private var location: String = ""
    @State private var isButtonEnabled = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                VStack(spacing: 10) {
                    HStack(alignment: .center){
                        Text("Назва:").frame(width: 90)
                            .font(.headline)
                        TextField("Назва стенду", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(10)
                            .keyboardType(.default).overlay(alignment: .trailing){
                                Text("*").foregroundColor(Color.red).offset(x: -15, y: -5).font(.title3)
                            }
                    }
                    HStack {
                        Text("Місткість:").frame(width: 90)
                            .font(.headline).alignmentGuide(.leading) { d in d[.leading] }
                        TextField("Введіть місткість:", text: $capacity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(10)
                            .keyboardType(.numberPad).overlay(alignment: .trailing){
                                Text("*").foregroundColor(Color.red).offset(x: -15, y: -5).font(.title3)
                            }
                    }
                    HStack {
                        Text("Позиція:").frame(width: 90)
                            .font(.headline).alignmentGuide(.leading) { d in d[.leading] }
                        TextField("Введіть позицію", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(10)
                            .keyboardType(.default).overlay(alignment: .trailing){
                                Text("*").foregroundColor(Color.red).offset(x: -15, y: -5).font(.title3)
                            }
                    }
                }
                
                Spacer()
                Button(action: {
                    FirebaseService.shared.createStand(stand: Stand(name: name, location: location, capacity: Int(capacity) ?? 0))
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Додати")
                }
                .disabled(!isButtonEnabled)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                .background(isButtonEnabled ? Color.blue : Color.gray.opacity(0.8))
                .foregroundColor(isButtonEnabled ? Color.white : Color.white.opacity(0.5))
                .cornerRadius(5)
                .padding()
                
            }
            .onChange(of: [name, capacity, location]) { value in
                let isNotEmpty = !value.contains("")
                self.isButtonEnabled = isNotEmpty
            }.padding(10)
        }.navigationBarTitle("Додати стенд")
    }
}

struct CreateStandView_Previews: PreviewProvider {
    static var previews: some View {
        CreateStandView()
    }
}
