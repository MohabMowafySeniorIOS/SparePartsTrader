//
//  ChoosePaymentWayModel.swift
//  SpareParts
//
//  Created by Mohab on 25/02/2026.
//

import Foundation
struct checkOutModel: Codable {
    let action: String?
    let payment_method: String?
    let redirect_url: String?
    
    enum CodingKeys: String, CodingKey {
        case action, payment_method, redirect_url
    }
}

struct PaymentData: Codable {
    let gateways: [Gateway]
}

struct Gateway: Codable, Identifiable {
    let id: String
    let name: String
    let label: String
    let description: String
    let icon: String?
    let requiresBrand: Bool
    let brands: [BrandGateway]

    enum CodingKeys: String, CodingKey {
        case id, name, label, description, icon, brands
        case requiresBrand = "requires_brand"
    }
}

struct BrandGateway: Codable {
    let id: String?
    let name: String?
    let icon: String?
}
