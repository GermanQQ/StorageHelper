//
//  FirebaseService.swift
//  StorageHelper
//
//  Created by Vadim German on 16.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class FirebaseService{
    private let stands = "stands"
    private let products = "products"
    private let client = "client"
    
    static let shared = FirebaseService()
    let db : Firestore
    let storage : Storage
    init() {
        db = Firestore.firestore()
        storage = Storage.storage()
    }
    
    func getStandsPath() -> String {
        return "\(client)__\(stands)"
    }
    
    func getProductsPath() -> String {
        return "\(client)__\(products)"
    }
    
    func getStands() async -> [Stand] {
        var documentNames : [Stand] = []
        // Get the documents in the collection\
        
        let querySnapshot = try? await db.collection(getStandsPath()).getDocuments()
        
        if querySnapshot != nil{
            documentNames = querySnapshot!.documents.map{ parseDictToStand(data: $0.data()) }
        }
        return documentNames;
    }
    
    func getProductsByStand(stand: Stand, completion: @escaping ([Product]) -> Void) {
        guard(!products.isEmpty) else {
            completion([])
            return
        }
        
        db.collection(getProductsPath()).getDocuments() { (querySnapshot, error) in
            guard error == nil, let querySnapshot = querySnapshot else {
                completion([])
                return
            }
            let products = querySnapshot.documents.filter { document in
                stand.productsIds.keys.contains(document.documentID)
            }.map { parseDictToProduct(data: $0.data(), stock: stand.productsIds[$0.documentID]?["qty"] as! Int?)
            }
            completion(products)
        }
    }
    
    
    //    func getProducts() async -> [Product] {
    //        var documentNames : [Product] = []
    //        // Get the documents in the collection\
    //
    //        let querySnapshot = try? await  db.collection(getProductsPath()).getDocuments()
    //
    //        if querySnapshot != nil{
    //            documentNames = querySnapshot!.documents.map{ parseDictToProduct(data: $0.data()) }
    //        }
    //        return documentNames;
    //    }
    
    func createStand(stand: Stand){
        db.collection(getStandsPath()).document(stand.id).setData(stand.convertToDict())
    }
    
    func searchDocumentProduct(barcode: String, completion: @escaping (Product?) -> Void) {
        if(barcode.isEmpty){
            completion(nil)
            return
        }
        let documentRef = db.collection(getProductsPath()).document(barcode)
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let product = parseDictToProduct(data: document.data() ?? [:])
                completion(product)
            } else {
                completion(nil)
            }
        }
    }
    
    fileprivate func uploadImageToStorage(_ product: Product, _ imageData: Data?) {
        let storageRef = storage.reference().child("client__products/\(product.image)")
        storageRef.putData(imageData!, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Error uploading image: \(error!)")
                return
            }
            print("Successfully uploaded image to Firebase Storage")
        }
    }
    
    func createProduct(product: Product, standId: String, imageData: Data? ){
        if(imageData != nil){
            uploadImageToStorage(product, imageData)
        }
        
        db.collection(getProductsPath()).document(product.barcode).setData(product.convertToDict())
        updateProductsInStand(product: product, standId: standId)
    }
    
    
    func getImageFromStorage(url: String, completion: @escaping (Data?) -> ()) {
        let storageRef = Storage.storage().reference(withPath: "client__products/\(url)")
        storageRef.getData(maxSize: 3000000) { data, error in
            if error != nil {
                // Handle error
                print("Error downloading image: \(error!)")
                completion(nil)
            } else {
                completion(data)
            }
        }
    }
    
    func updateProductsInStand(product: Product, standId: String){
        let documentRef = db.collection(getStandsPath()).document(standId)
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var stand = parseDictToStand(data: document.data() ?? [:])
                stand.productsIds[product.barcode] = ["qty": product.stock]
                stand.filled = stand.filled + product.stock
                self.db.collection(self.getStandsPath()).document(standId).updateData(stand.convertToDict())
            }
        }
    }
    
    func setProductToStand(product: Product, standId: String, qty: Int){
        let documentRef = db.collection(getProductsPath()).document(product.barcode)
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let product = parseDictToProduct(data: document.data() ?? [:])
                
                self.db.collection(self.getProductsPath()).document(standId).updateData(product.copyWith(stock: product.stock + qty) .convertToDict())
            }
        }
        
        updateProductsInStand(product: product.copyWith(stock: qty), standId: standId)
        
    }
    
    //    func exampleSearchDocumentsProducts(byQuery query: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void) {
    //        db.collection(getProductsPath())
    //            .whereField("fieldName", isGreaterThanOrEqualTo: query)
    //            .whereField("fieldName", isLessThan: query+"\u{f8ff}")
    //            .getDocuments { (querySnapshot, error) in
    //                if let error = error {
    //                    print("Error searching documents: \(error)")
    //                    return
    //                }
    //                if let documents = querySnapshot?.documents {
    //                    completion(documents)
    //                }
    //            }
    //    }
    
    
}
