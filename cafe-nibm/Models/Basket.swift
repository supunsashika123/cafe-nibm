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
    var qty: Float
    var total: Float
}

func saveBasket(_ basket: [Basket]) {
    UserDefaults.standard.set(try? PropertyListEncoder().encode(basket), forKey:"BASKET")
}

