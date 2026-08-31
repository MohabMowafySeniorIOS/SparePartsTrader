//
//  TraderModel.swift
//  SpareParts
//
//  Created by Mohab on 07/02/2026.
//

import Foundation

struct TradersResponse: Codable {
    var data: [Trader]?
    let links: PaginationLinks?
    let meta: PaginationMeta?
}

struct Trader: Codable, Identifiable,Hashable,Equatable {
    let id: Int
    let userId: Int?
    let tradeName: String?
    let description: String?
    let logo: Logo?
    let images: [VendorImage]?
    var country: Country?
    var city: City?
    let ratingAvg: Double?
    let ratingCount: Double?
    let isReceivingOrders: Bool?
    let latitude: Double?
    let longitude: Double?
    var isFavorite: Bool = false
    let address: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case tradeName = "trade_name"
        case description
        case logo
        case images
        case country
        case city
        case ratingAvg = "rating_avg"
        case ratingCount = "rating_count"
        case isReceivingOrders = "is_receiving_orders"
        case latitude
        case longitude
        case isFavorite = "is_favorite"
        case address
    }
    
    mutating func toggleFavourite(){
        isFavorite = !isFavorite
    }
}

struct City: Codable, Hashable,Equatable {
    let id: Int?
    var name: String?
}

struct Country: Codable,Hashable,Equatable {
    let id: Int?
    let name: String?
}

struct PaginationLinks: Codable {
    let first: String?
    let last: String?
    let prev: String?
    let next: String?
}

struct PaginationMeta: Codable {
    let currentPage: Int?
    let from: Int?
    let lastPage: Int?
    let perPage: Int?
    let to: Int?
    let total: Int?
    let path: String?
    let links: [PaginationMetaLink]?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case perPage = "per_page"
        case to
        case total
        case path
        case links
    }
}

struct PaginationMetaLink: Codable {
    let url: String?
    let label: String?
    let page: Int?
    let active: Bool?
}

struct LogoAdd: Codable, Hashable, Equatable {
    let id: String?
    let isSingle: Bool?
    let modelID: Int?
    let modelType: String?
    let option: String?
    let path: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case isSingle = "is_single"
        case modelID = "model_id"
        case modelType = "model_type"
        case option
        case path
        case type
    }
}
struct Logo: Codable, Hashable, Equatable {
    let id: String?
    let isSingle: Bool?
    let modelID: String?
    let modelType: String?
    let option: String?
    let path: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case isSingle = "is_single"
        case modelID = "model_id"
        case modelType = "model_type"
        case option
        case path
        case type
    }
}

struct IsFavouriteModel: Codable {
    let isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case isFavorite = "is_favorite"
    }
}



// MARK: - Image
struct VendorImage: Codable, Hashable, Equatable {
    let id: String?
    let path: String?
    let type, option: String?
}
