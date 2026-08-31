//
//  SendOfferModel.swift
//  SpareParts
//
//  Created by Mohab on 04/03/2026.
//

import Foundation
struct SendOfferData : Codable {
    let order_id : Int?
    let trader_id : Int?
    let status : String?
    let subtotal : String?
    let tax_amount : String?
    let shipping_cost : String?
    let total_amount : String?
    let platform_commission : String?
    let trader_earning : String?
    let updated_at : String?
    let created_at : String?
    let id : Int?
    let items : [Items]?
    let order : OfferOrder?
    let trader_profile : Trader_profile?
    let trader : OfferTraderModel?

    enum CodingKeys: String, CodingKey {

        case order_id = "order_id"
        case trader_id = "trader_id"
        case status = "status"
        case subtotal = "subtotal"
        case tax_amount = "tax_amount"
        case shipping_cost = "shipping_cost"
        case total_amount = "total_amount"
        case platform_commission = "platform_commission"
        case trader_earning = "trader_earning"
        case updated_at = "updated_at"
        case created_at = "created_at"
        case id = "id"
        case items = "items"
        case order = "order"
        case trader_profile = "trader_profile"
        case trader = "trader"
    }

   

}

struct OfferTraderModel : Codable {
    let id : Int?
    let uuid : String?
    let full_name : String?
    let email : String?
    let phone_code : String?
    let phone : String?
    let city_id : Int?
    let phone_verified_at : String?
    let email_verified_at : String?
    let locale : String?
    let is_active : Bool?
    let is_admin_active : Int?
    let is_ban : Int?
    let is_banned : Bool?
    let banned_until : String?
    let user_type : String?
    let is_super : Bool?
    let reset_code : String?
    let is_notify : Int?
    let delete_reason : String?
    let deleted_at : String?
    let created_at : String?
    let updated_at : String?
    let role_id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case uuid = "uuid"
        case full_name = "full_name"
        case email = "email"
        case phone_code = "phone_code"
        case phone = "phone"
        case city_id = "city_id"
        case phone_verified_at = "phone_verified_at"
        case email_verified_at = "email_verified_at"
        case locale = "locale"
        case is_active = "is_active"
        case is_admin_active = "is_admin_active"
        case is_ban = "is_ban"
        case is_banned = "is_banned"
        case banned_until = "banned_until"
        case user_type = "user_type"
        case is_super = "is_super"
        case reset_code = "reset_code"
        case is_notify = "is_notify"
        case delete_reason = "delete_reason"
        case deleted_at = "deleted_at"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case role_id = "role_id"
    }

   
}

struct OfferOrder : Codable {
    let id : Int?
    let order_number : String?
    let user_id : Int?
    let trader_id : String?
    let vehicle_id : Int?
    let order_type : String?
    let delivery_type : String?
    let address_id : Int?
    let status : String?
    let subtotal : String?
    let shipping_cost : String?
    let tax_amount : String?
    let total_amount : String?
    let wallet_used : String?
    let paid_amount : String?
    let platform_commission : String?
    let trader_earning : String?
    let payment_method : String?
    let payment_reference : String?
    let paid_at : String?
    let completed_at : String?
    let cancelled_at : String?
    let cancellation_reason_id : String?
    let cancellation_notes : String?
    let created_at : String?
    let updated_at : String?
    let deleted_at : String?
    let user : User?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case order_number = "order_number"
        case user_id = "user_id"
        case trader_id = "trader_id"
        case vehicle_id = "vehicle_id"
        case order_type = "order_type"
        case delivery_type = "delivery_type"
        case address_id = "address_id"
        case status = "status"
        case subtotal = "subtotal"
        case shipping_cost = "shipping_cost"
        case tax_amount = "tax_amount"
        case total_amount = "total_amount"
        case wallet_used = "wallet_used"
        case paid_amount = "paid_amount"
        case platform_commission = "platform_commission"
        case trader_earning = "trader_earning"
        case payment_method = "payment_method"
        case payment_reference = "payment_reference"
        case paid_at = "paid_at"
        case completed_at = "completed_at"
        case cancelled_at = "cancelled_at"
        case cancellation_reason_id = "cancellation_reason_id"
        case cancellation_notes = "cancellation_notes"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case deleted_at = "deleted_at"
        case user = "user"
    }


}
struct Items : Codable {
    let id : Int?
    let offer_id : Int?
    let order_item_id : Int?
    let price : String?
    let is_available : Bool?
    let created_at : String?
    let updated_at : String?
    let order_item : Order_item?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case offer_id = "offer_id"
        case order_item_id = "order_item_id"
        case price = "price"
        case is_available = "is_available"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case order_item = "order_item"
    }


}
struct Order_item : Codable {
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

struct Trader_profile : Codable {
    let id : Int?
    let user_id : Int?
    let trade_name_ar : String?
    let trade_name_en : String?
    let description_ar : String?
    let description_en : String?
    let first_name_ar : String?
    let last_name_ar : String?
    let first_name_en : String?
    let last_name_en : String?
    let business_type : String?
    let gender : String?
    let phone : String?
    let whatsapp : String?
    let country_id : Int?
    let city_id : Int?
    let commercial_register : String?
    let is_verified : Bool?
    let is_active : Bool?
    let created_at : String?
    let updated_at : String?
    let latitude : String?
    let longitude : String?
    let address : String?
    let is_receiving_orders : Bool?
    let rating_avg : String?
    let rating_count : Int?
    let bank_name : String?
    let bank_account_name : String?
    let bank_account_number : String?
    let bank_iban : String?
    let status : String?
    let rejection_reason : String?
    let approved_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case trade_name_ar = "trade_name_ar"
        case trade_name_en = "trade_name_en"
        case description_ar = "description_ar"
        case description_en = "description_en"
        case first_name_ar = "first_name_ar"
        case last_name_ar = "last_name_ar"
        case first_name_en = "first_name_en"
        case last_name_en = "last_name_en"
        case business_type = "business_type"
        case gender = "gender"
        case phone = "phone"
        case whatsapp = "whatsapp"
        case country_id = "country_id"
        case city_id = "city_id"
        case commercial_register = "commercial_register"
        case is_verified = "is_verified"
        case is_active = "is_active"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case latitude = "latitude"
        case longitude = "longitude"
        case address = "address"
        case is_receiving_orders = "is_receiving_orders"
        case rating_avg = "rating_avg"
        case rating_count = "rating_count"
        case bank_name = "bank_name"
        case bank_account_name = "bank_account_name"
        case bank_account_number = "bank_account_number"
        case bank_iban = "bank_iban"
        case status = "status"
        case rejection_reason = "rejection_reason"
        case approved_at = "approved_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        trade_name_ar = try values.decodeIfPresent(String.self, forKey: .trade_name_ar)
        trade_name_en = try values.decodeIfPresent(String.self, forKey: .trade_name_en)
        description_ar = try values.decodeIfPresent(String.self, forKey: .description_ar)
        description_en = try values.decodeIfPresent(String.self, forKey: .description_en)
        first_name_ar = try values.decodeIfPresent(String.self, forKey: .first_name_ar)
        last_name_ar = try values.decodeIfPresent(String.self, forKey: .last_name_ar)
        first_name_en = try values.decodeIfPresent(String.self, forKey: .first_name_en)
        last_name_en = try values.decodeIfPresent(String.self, forKey: .last_name_en)
        business_type = try values.decodeIfPresent(String.self, forKey: .business_type)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        whatsapp = try values.decodeIfPresent(String.self, forKey: .whatsapp)
        country_id = try values.decodeIfPresent(Int.self, forKey: .country_id)
        city_id = try values.decodeIfPresent(Int.self, forKey: .city_id)
        commercial_register = try values.decodeIfPresent(String.self, forKey: .commercial_register)
        is_verified = try values.decodeIfPresent(Bool.self, forKey: .is_verified)
        is_active = try values.decodeIfPresent(Bool.self, forKey: .is_active)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        is_receiving_orders = try values.decodeIfPresent(Bool.self, forKey: .is_receiving_orders)
        rating_avg = try values.decodeIfPresent(String.self, forKey: .rating_avg)
        rating_count = try values.decodeIfPresent(Int.self, forKey: .rating_count)
        bank_name = try values.decodeIfPresent(String.self, forKey: .bank_name)
        bank_account_name = try values.decodeIfPresent(String.self, forKey: .bank_account_name)
        bank_account_number = try values.decodeIfPresent(String.self, forKey: .bank_account_number)
        bank_iban = try values.decodeIfPresent(String.self, forKey: .bank_iban)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        rejection_reason = try values.decodeIfPresent(String.self, forKey: .rejection_reason)
        approved_at = try values.decodeIfPresent(String.self, forKey: .approved_at)
    }

}
