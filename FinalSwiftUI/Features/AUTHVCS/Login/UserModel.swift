//
//  UserModel.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 28/11/2024.
//


import Foundation



struct LoginData: Codable, Equatable, Hashable {
    let id : String?
    var full_name : String?
    var user_type : String?
    var email : String?
    var avatar : Avatar?
    var phone : String?
    var is_active : Bool?
    var locale : String?
    var is_notify : Bool?
    var token : String?
    var trader : LoginTrader?
    
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case full_name = "full_name"
        case user_type = "user_type"
        case email = "email"
        case avatar = "avatar"
        case phone = "phone"
        case is_active = "is_active"
        case locale = "locale"
        case is_notify = "is_notify"
        case token = "token"
        case trader = "trader"
     
    }

}
struct LoginTrader : Codable, Equatable, Hashable {
    let id : Int?
    let first_name_ar : String?
    let last_name_ar : String?
    let first_name_en : String?
    let last_name_en : String?
    let full_name : String?
    let full_name_en : String?
    let trade_name : String?
    let trade_name_ar : String?
    let trade_name_en : String?
    let description : String?
    let description_ar : String?
    let description_en : String?
    let business_type : String?
    let gender : String?
    let whatsapp : String?
    let commercial_register : String?
    let country_id : Int?
    var country : Country?
    let city_id : Int?
    var city : City?
    let address : String?
    let latitude : Double?
    let longitude : Double?
    let logo : Logo?
    let images : [Logo]?
    let commercial_register_image : Logo?
    let bank_name : String?
    let bank_account_name : String?
    let bank_account_number : String?
    let bank_iban : String?
    let status : String?
    let is_verified : Bool?
    let is_active : Bool?
    let is_receiving_orders : Bool?
    let rating_avg : Double?
    let rating_count : Int?
    let rejection_reason : String?
    let approved_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case first_name_ar = "first_name_ar"
        case last_name_ar = "last_name_ar"
        case first_name_en = "first_name_en"
        case last_name_en = "last_name_en"
        case full_name = "full_name"
        case full_name_en = "full_name_en"
        case trade_name = "trade_name"
        case trade_name_ar = "trade_name_ar"
        case trade_name_en = "trade_name_en"
        case description = "description"
        case description_ar = "description_ar"
        case description_en = "description_en"
        case business_type = "business_type"
        case gender = "gender"
        case whatsapp = "whatsapp"
        case commercial_register = "commercial_register"
        case country_id = "country_id"
        case country = "country"
        case city_id = "city_id"
        case city = "city"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case logo = "logo"
        case images = "images"
        case commercial_register_image = "commercial_register_image"
        case bank_name = "bank_name"
        case bank_account_name = "bank_account_name"
        case bank_account_number = "bank_account_number"
        case bank_iban = "bank_iban"
        case status = "status"
        case is_verified = "is_verified"
        case is_active = "is_active"
        case is_receiving_orders = "is_receiving_orders"
        case rating_avg = "rating_avg"
        case rating_count = "rating_count"
        case rejection_reason = "rejection_reason"
        case approved_at = "approved_at"
    }


}



struct Avatar : Codable, Equatable, Hashable {
    let id : String?
    let path : String?
    let type : String?
    let option : String?
    let model_id : String?
    let model_type : String?
    let is_single : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case path = "path"
        case type = "type"
        case option = "option"
        case model_id = "model_id"
        case model_type = "model_type"
        case is_single = "is_single"
    }

    

}
