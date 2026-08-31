//
//  OrderCancelModel.swift
//  SpareParts
//
//  Created by Mohamed Elboraey on 17/02/2026.
//

import Foundation

struct OrderCancelModel: Codable {
    let addressId: Int?
    let cancellationNotes: String?
    let cancellationReasonId: Int?
    let cancelledAt: String?
    let completedAt: String?
    let createdAt: String?
    let deletedAt: String?
    let deliveryType: String?
    let id: Int?
    let orderNumber: String?
    let orderType: String?
    let paidAmount: String?
    let paidAt: String?
    let paymentMethod: String?
    let paymentReference: String?
    let platformCommission: String?
    let shippingCost: String?
    let status: Status?
    let subtotal: String?
    let taxAmount: String?
    let totalAmount: String?
    let traderEarning: String?
    let traderId: Int?
    let updatedAt: String?
    let userId: Int?
    let vehicleId: Int?
    let walletUsed: String?
    
    enum CodingKeys: String, CodingKey {
        case addressId = "address_id"
        case cancellationNotes = "cancellation_notes"
        case cancellationReasonId = "cancellation_reason_id"
        case cancelledAt = "cancelled_at"
        case completedAt = "completed_at"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case deliveryType = "delivery_type"
        case id
        case orderNumber = "order_number"
        case orderType = "order_type"
        case paidAmount = "paid_amount"
        case paidAt = "paid_at"
        case paymentMethod = "payment_method"
        case paymentReference = "payment_reference"
        case platformCommission = "platform_commission"
        case shippingCost = "shipping_cost"
        case status
        case subtotal
        case taxAmount = "tax_amount"
        case totalAmount = "total_amount"
        case traderEarning = "trader_earning"
        case traderId = "trader_id"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case vehicleId = "vehicle_id"
        case walletUsed = "wallet_used"
    }
}

