//
//  StandModel.swift
//  StorageHelper
//
//  Created by Vadim German on 18.01.2023.
//

import Foundation

struct Stand: Identifiable{
    var id = UUID().uuidString
    var name, location: String
    var capacity: Int
    var filled: Int = 0
    var productsIds: [String] = []
}

extension Stand{
    func convertToDict() -> Dictionary<String, Any> {
        ["id": self.id,
         "name": self.name,
         "capacity": self.capacity,
         "location": self.location,
         "filled": self.filled,
         "productsIds" : self.productsIds]
    }
}

func parseDictToStand(data: Dictionary<String, Any>)-> Stand{
    
    return Stand(id: data["id"] as? String ?? "",
                 name: data["name"] as? String ?? "",
                 location: data["location"] as? String ?? "",
                 capacity: data["capacity"] as? Int ?? 0,
                 filled: data["filled"] as? Int ?? 0,
                 productsIds: data["productsIds"] as? Array ?? []
    )
}
