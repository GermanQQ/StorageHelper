//
//  FirebaseModel.swift
//  StorageHelper
//
//  Created by Vadim German on 16.01.2023.
//

import Foundation

struct Product: Hashable {
    var id = UUID().uuidString
    var name, description, image, barcode: String
    var stock: Int
}

extension Product{
    func convertToDict() -> Dictionary<String, Any> {
        ["id": self.id,
         "name": self.name,
         "description": self.description,
         "image": self.image,
         "barcode": self.barcode,
         "stock" : self.stock]
    }
    
    func copyWith(name: String? = nil, description: String? = nil, image: String? = nil, barcode: String? = nil, stock: Int? = nil ) -> Product{
        Product(name: name ?? self.name, description: description ?? self.description, image: image ?? self.image, barcode: barcode ?? self.barcode, stock: stock ?? self.stock)
    }
}

func parseDictToProduct(data: Dictionary<String, Any>, stock: Int? = nil)-> Product{
    
    return Product(id: data["id"] as? String ?? "",
                   name: data["name"] as? String ?? "",
                   description: data["description"] as? String ?? "",
                   image: data["image"] as? String ?? "",
                   barcode: data["barcode"] as? String ?? "",
                   stock: stock ?? data["stock"] as? Int ?? 0
    )
}
