//
//  HomeResponse.swift
//  SpareParts
//
//  Created by Mohab on 07/02/2026.
//

import Foundation

// MARK: - DataClass

struct HomeResponse: Codable {
    var banners: [Banner]?
    var topTraders: [Trader]?

    enum CodingKeys: String, CodingKey {
        case banners
        case topTraders = "top_traders"
    }
}

// MARK: - Banner
struct Banner: Codable {
    let id: Int?
    let title: String?
    let image: VendorImage?
    let linkType: String?
    let linkValue: String?
    let traderID: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, image
        case linkType = "link_type"
        case linkValue = "link_value"
        case traderID = "trader_id"
    }
}

// MARK: - TopTrader
struct TopTrader: Codable {
    let id, userID: Int?
    let tradeName, description: String?
    let logo: Logo?
    let images: [Logo]?
    let country, city: City?
    let ratingAvg: Double?
    let ratingCount: Int?
    let isReceivingOrders: Bool?
    let latitude, longitude: Double?
    let isFavorite: Bool?
    let address: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case tradeName = "trade_name"
        case description, logo, images, country, city
        case ratingAvg = "rating_avg"
        case ratingCount = "rating_count"
        case isReceivingOrders = "is_receiving_orders"
        case latitude, longitude
        case isFavorite = "is_favorite"
        case address
    }
}
