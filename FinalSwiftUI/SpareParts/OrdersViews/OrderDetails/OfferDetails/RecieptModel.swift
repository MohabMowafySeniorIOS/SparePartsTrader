//
//  RecieptModel.swift
//  SpareParts
//
//  Created by Mohab on 25/02/2026.
//

import Foundation
struct RecieptModel: Codable {

    let id: Int
    let orderNumber: String
    let orderType: String
    let deliveryType: String
    let status: String

    let addressId: Int?
    let userId: Int?
    let traderId: Int?
    let vehicleId: Int?

    let subtotal: String?
    let taxAmount: String?
    let shippingCost: String?
    let totalAmount: String?
    let paidAmount: String?
    let walletUsed: String?
    let traderEarning: String?
    let platformCommission: String?

    let paymentMethod: String?
    let paymentReference: String?
    let paidAt: String?

    let createdAt: String?
    let updatedAt: String?
    let completedAt: String?

    let trader: TraderModel?

    enum CodingKeys: String, CodingKey {
        case id, status, subtotal, trader
        case orderNumber = "order_number"
        case orderType = "order_type"
        case deliveryType = "delivery_type"
        case addressId = "address_id"
        case userId = "user_id"
        case traderId = "trader_id"
        case vehicleId = "vehicle_id"
        case taxAmount = "tax_amount"
        case shippingCost = "shipping_cost"
        case totalAmount = "total_amount"
        case paidAmount = "paid_amount"
        case walletUsed = "wallet_used"
        case traderEarning = "trader_earning"
        case platformCommission = "platform_commission"
        case paymentMethod = "payment_method"
        case paymentReference = "payment_reference"
        case paidAt = "paid_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case completedAt = "completed_at"
    }
}
struct TraderModel: Codable {

    let id: Int
    let fullName: String?
    let email: String?
    let phone: String?
    let locale: String?
    let userType: String?
    let uuid: String?

    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, email, phone, locale, uuid
        case fullName = "full_name"
        case userType = "user_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
