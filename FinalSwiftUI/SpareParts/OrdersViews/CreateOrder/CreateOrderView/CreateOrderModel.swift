//
//  CreateOrderModel.swift
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//

import Foundation
import SwiftUI

struct Car: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}
struct AddedAddressModel: Identifiable {
    let id = UUID()
    let address: String
    var isSelected: Bool
}

struct PartModel: Identifiable {
    let id = UUID()
    let name: String
    let number: String
    let type: String
    let quantity: String
    let describtion: String
    let pickedImages: [UIImage] 
}

struct Targets: Identifiable {
    let id: Int?
   
    let type: String
   
}

enum DeliveryTypeEnum: String{
    case shop = "pickup"
    case home = "delivery"
}

struct CreateOrderModel : Codable {
    let user_id : Int?
    let vehicle_id : String?
    let order_type : String?
    let delivery_type : String?
    let address_id : String?
    let status : String?
    let order_number : String?
    let updated_at : String?
    let created_at : String?
    let id : Int?
    let vehicle : Vehicle?
    let items : [ItemsModel]?
    let targets : [TargetsModel]?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case vehicle_id = "vehicle_id"
        case order_type = "order_type"
        case delivery_type = "delivery_type"
        case address_id = "address_id"
        case status = "status"
        case order_number = "order_number"
        case updated_at = "updated_at"
        case created_at = "created_at"
        case id = "id"
        case vehicle = "vehicle"
        case items = "items"
        case targets = "targets"
    }

   

}




struct ItemsModel : Codable {
    let id : Int?
    let order_id : Int?
    let part_name : String?
    let part_number : String?
    let part_type : String?
    let quantity : Int?
    let description : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case order_id = "order_id"
        case part_name = "part_name"
        case part_number = "part_number"
        case part_type = "part_type"
        case quantity = "quantity"
        case description = "description"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        part_name = try values.decodeIfPresent(String.self, forKey: .part_name)
        part_number = try values.decodeIfPresent(String.self, forKey: .part_number)
        part_type = try values.decodeIfPresent(String.self, forKey: .part_type)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
struct TargetsModel : Codable {
    let id : Int?
    let order_id : Int?
    let target_type : String?
    let target_id : Int?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case order_id = "order_id"
        case target_type = "target_type"
        case target_id = "target_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        target_type = try values.decodeIfPresent(String.self, forKey: .target_type)
        target_id = try values.decodeIfPresent(Int.self, forKey: .target_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
