//
//  Order.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-04-25.
//

import Foundation
import FirebaseFirestoreSwift

struct Order:Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var date: Date
    var total_price: Float
    var user_id: String
    var status: String
    var items: [Basket]
}
