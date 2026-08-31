//
//  VendorDetailsModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import Foundation

// MARK: - VendorDetailsModel
struct VendorDetailsModel: Codable, Equatable , Hashable {
  
    
    let id, userID: Int?
    let tradeName, description: String?
    let logo: Logo?
    let images: [VendorImage]?
    let phone, whatsapp: String?
    let country, city: City?
    let ratingAvg: Double?
    let ratingCount: Int?
    let isReceivingOrders: Bool?
    let latitude, longitude: Double?
    let address: String?
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case tradeName = "trade_name"
        case description, logo, images, phone, whatsapp, country, city
        case ratingAvg = "rating_avg"
        case ratingCount = "rating_count"
        case isReceivingOrders = "is_receiving_orders"
        case latitude, longitude, address
        case isFavorite = "is_favorite"
    }
}

