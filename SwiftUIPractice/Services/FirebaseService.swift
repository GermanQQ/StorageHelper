//
//  FirebaseService.swift
//  StorageHelper
//
//  Created by Vadim German on 16.01.2023.
//

import Foundation
import FirebaseFirestore

class FirebaseService{
    private let stands = "stands"
    private let products = "products"
    private let client = "client"
    
    static let shared = FirebaseService()
    let db : Firestore
    init() {
        db = Firestore.firestore()
    }
    
    private func getStandsRef() -> CollectionReference {
        let standsPath = "\(client)__\(stands)"
        return db.collection(standsPath)
    }
    
    func getStandsPath() -> String {
        return "\(client)__\(stands)"
    }
    
    func getStands() async -> [Stand] {
        var documentNames : [Stand] = []
        // Get the documents in the collection\
        
        
        let querySnapshot = try? await getStandsRef().getDocuments()
        
        if querySnapshot != nil{
            documentNames = querySnapshot!.documents.map{ parseDictToStand(data: $0.data()) }
        }
        return documentNames;
    }
    
    func createStand(stand: Stand){
        getStandsRef().document(stand.id).setData(stand.convertToDict())
    }
    
}
