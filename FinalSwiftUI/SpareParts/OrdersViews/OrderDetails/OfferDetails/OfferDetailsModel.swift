//
//  OfferDetailsModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//

import Foundation
struct OfferDetailsModel: Codable {
        let id: Int
       let orderNumber: String
       let orderType: String
       let deliveryType: String
       let status: String

       let addressId: Int?
       let vehicleId: Int?
       let userId: Int?

       let subtotal: String?
       let taxAmount: String?
       let shippingCost: String?
       let totalAmount: String?
       let platformCommission: String?
       let traderEarning: String?

       let paidAmount: String?
       let paymentMethod: String?
       let paymentReference: String?

       let createdAt: String?
       let updatedAt: String?

       let acceptedOffer: AcceptedOffer?
       let trader: OfferTrader?
       let traderProfile: TraderProfile?

       enum CodingKeys: String, CodingKey {
           case id, status, subtotal, trader, vehicleId = "vehicle_id", userId = "user_id"
           case orderNumber = "order_number"
           case orderType = "order_type"
           case deliveryType = "delivery_type"
           case addressId = "address_id"
           case taxAmount = "tax_amount"
           case shippingCost = "shipping_cost"
           case totalAmount = "total_amount"
           case platformCommission = "platform_commission"
           case traderEarning = "trader_earning"
           case paidAmount = "paid_amount"
           case paymentMethod = "payment_method"
           case paymentReference = "payment_reference"
           case createdAt = "created_at"
           case updatedAt = "updated_at"
           case acceptedOffer = "accepted_offer"
           case traderProfile = "trader_profile"
       }
   }
struct OfferTrader: Codable {
    let id: Int
    let fullName: String?
    let email: String?
    let phone: String?
    let locale: String?
    let userType: String?
    let uuid: String?

    enum CodingKeys: String, CodingKey {
        case id, email, phone, locale, uuid
        case fullName = "full_name"
        case userType = "user_type"
    }
}
struct AcceptedOffer: Codable {
    let id: Int
    let orderId: Int
    let traderId: Int
    let status: String

    let subtotal: String?
    let taxAmount: String?
    let shippingCost: String?
    let totalAmount: String?
    let traderEarning: String?
    let platformCommission: String?

    let createdAt: String?
    let updatedAt: String?
    let acceptedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, status
        case orderId = "order_id"
        case traderId = "trader_id"
        case subtotal
        case taxAmount = "tax_amount"
        case shippingCost = "shipping_cost"
        case totalAmount = "total_amount"
        case traderEarning = "trader_earning"
        case platformCommission = "platform_commission"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case acceptedAt = "accepted_at"
    }
}
struct TraderProfile: Codable {
    let id: Int
    let userId: Int?

    let tradeNameAr: String?
    let tradeNameEn: String?

    let firstNameAr: String?
    let firstNameEn: String?
    let lastNameAr: String?
    let lastNameEn: String?

    let descriptionAr: String?
    let descriptionEn: String?

    let ratingAvg: String?
    let ratingCount: Int?

    let latitude: String?
    let longitude: String?

    enum CodingKeys: String, CodingKey {
        case id, latitude, longitude
        case userId = "user_id"
        case tradeNameAr = "trade_name_ar"
        case tradeNameEn = "trade_name_en"
        case firstNameAr = "first_name_ar"
        case firstNameEn = "first_name_en"
        case lastNameAr = "last_name_ar"
        case lastNameEn = "last_name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case ratingAvg = "rating_avg"
        case ratingCount = "rating_count"
    }
}
