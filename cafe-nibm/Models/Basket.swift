//
//  Basket.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-03-07.
//

import Foundation

struct Basket:Identifiable, Codable {
    var id: String? = UUID().uuidString
    var name: String
    var qty: Int
    var total: Float
    
    func convertToDictionary() -> [String : Any] {
        let dic: [String: Any] = [
            "name":self.name,
            "qty":self.qty,
            "total":self.total
        ]
        return dic
    }
}

func saveBasket(_ basket: [Basket]) {
    UserDefaults.standard.set(try? PropertyListEncoder().encode(basket), forKey:"BASKET")
}
