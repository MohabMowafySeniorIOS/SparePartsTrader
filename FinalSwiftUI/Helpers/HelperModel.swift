//
//  HelperModel.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 12/01/2025.
//

import Foundation
import Foundation
struct BaseModel<T:Codable>: Codable {
    let status: String?
    let message: String?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
       
    }
}

struct BaseModelPaginate<T:Codable>: Codable {
    let status : String?
    var data : BaseModelWithPagination<T>?
    let message: String?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct BaseModelWithPagination<T:Codable>: Codable {
    let data : T?
    let pagination : Pagination?
    let Links : Links?
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case pagination = "pagination"
        case Links = "Links"
    }
}

struct Links : Codable {
    let first : String?
    let last : String?
    let prev : String?
    let next : String?
    enum CodingKeys: String, CodingKey {
        case first = "first"
        case last = "last"
        case prev = "prev"
        case next = "next"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first = try values.decodeIfPresent(String.self, forKey: .first)
        last = try values.decodeIfPresent(String.self, forKey: .last)
        prev = try values.decodeIfPresent(String.self, forKey: .prev)
        next = try values.decodeIfPresent(String.self, forKey: .next)
    }

}
