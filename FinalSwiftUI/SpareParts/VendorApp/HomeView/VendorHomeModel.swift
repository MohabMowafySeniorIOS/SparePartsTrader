//
//  VendorHomeModel.swift
//  SpareParts
//
//  Created by Mohab on 26/02/2026.
//

import Foundation
struct VendorHomeData : Codable {
    let is_receiving_orders : Bool?
    let offers : Offers?
    let orders : Orders?
    let financial : Financial?
    let rating : Rating?
    let latest_orders : [Order]?

    enum CodingKeys: String, CodingKey {

        case is_receiving_orders = "is_receiving_orders"
        case offers = "offers"
        case orders = "orders"
        case financial = "financial"
        case rating = "rating"
        case latest_orders = "latest_orders"
    }


}
struct Financial : Codable {
    let total_earnings : Double?
    let wallet_balance : Double?
    let this_month_earnings : Double?
    let pending_earnings : Double?

    enum CodingKeys: String, CodingKey {

        case total_earnings = "total_earnings"
        case wallet_balance = "wallet_balance"
        case this_month_earnings = "this_month_earnings"
        case pending_earnings = "pending_earnings"
    }


}
struct Offers : Codable {
    let total : Int?
    let pending : Int?
    let accepted : Int?
    let rejected : Int?
    let total_value : Float?
    let acceptance_rate : Float?

    enum CodingKeys: String, CodingKey {

        case total = "total"
        case pending = "pending"
        case accepted = "accepted"
        case rejected = "rejected"
        case total_value = "total_value"
        case acceptance_rate = "acceptance_rate"
    }

   

}
struct Rating : Codable {
    let average : Double?
    let count : Double?

    enum CodingKeys: String, CodingKey {

        case average = "average"
        case count = "count"
    }

   

}
struct Orders : Codable {
    let total : Double?
    let in_progress : Double?
    let completed : Double?
    let cancelled : Double?
    let total_value : Float?
    let completion_rate : Double?

    enum CodingKeys: String, CodingKey {

        case total = "total"
        case in_progress = "in_progress"
        case completed = "completed"
        case cancelled = "cancelled"
        case total_value = "total_value"
        case completion_rate = "completion_rate"
    }

  

}


struct RecivingOrderModel : Codable {
    let is_receiving_orders : Bool?
   
    enum CodingKeys: String, CodingKey {

        case is_receiving_orders = "is_receiving_orders"
      
    }


}
struct Latest_orders : Codable {
    let id : Int?
    let order_number : String?
    let order_type : Order_type?
    let delivery_type : Order_type?
    let status : Status?
    let created_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case order_number = "order_number"
        case order_type = "order_type"
        case delivery_type = "delivery_type"
        case status = "status"
        case created_at = "created_at"
    }

   

}
struct Order_type : Codable {
    let value : String?
    let label : String?

    enum CodingKeys: String, CodingKey {

        case value = "value"
        case label = "label"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        label = try values.decodeIfPresent(String.self, forKey: .label)
    }

}
