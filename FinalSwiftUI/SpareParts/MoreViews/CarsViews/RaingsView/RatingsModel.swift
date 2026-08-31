//
//  RatingsModel.swift
//  MyAuctions
//
//  Created by Mohab on 07/07/2025.
//

import Foundation
struct RatingCard: Codable, Identifiable {
    let id = UUID()
    let stats : Stats?
    let ratings : Ratings?

    enum CodingKeys: String, CodingKey {

        case stats = "stats"
        case ratings = "ratings"
    }

   

}

struct Ratings : Codable {
    let data : [ratingData]?
    let links : Links?
    let meta : Meta?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case links = "links"
        case meta = "meta"
    }


}
struct ratingData : Codable {
    let id : Int?
    let order_number : String?
    let rating : Double?
    let comment : String?
    let user : User?
    let trader : TraderRating?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case order_number = "order_number"
        case rating = "rating"
        case comment = "comment"
        case user = "user"
        case trader = "trader"
    }

   

}

struct Stats : Codable {
    let average : String?
    let total : Int?
    let breakdown : Breakdown?

    enum CodingKeys: String, CodingKey {

        case average = "average"
        case total = "total"
        case breakdown = "breakdown"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        average = try values.decodeIfPresent(String.self, forKey: .average)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        breakdown = try values.decodeIfPresent(Breakdown.self, forKey: .breakdown)
    }

}
struct Breakdown : Codable {
    let five : Int?
    let foure : Int?
    let three : Int?
    let tow : Int?
    let one : Int?

    enum CodingKeys: String, CodingKey {

        case five = "5"
        case foure = "4"
        case three = "3"
        case tow = "2"
        case one = "1"
    }

   

}
struct User : Codable {
    let id : Int?
    let name : String?
    let avatar : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case avatar = "avatar"
    }

    

}

struct TraderRating : Codable {
    let id : Int?
    let name : String?
    let logo : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case logo = "logo"
    }

   

}
