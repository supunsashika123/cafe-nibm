//
//  Item.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-03-07.
//

import Foundation
import FirebaseFirestoreSwift

struct Item:Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var price: Float
    var description: String
}
