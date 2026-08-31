//
//  ChatModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 7/5/25.
//

import Foundation

struct messageModelPaginate: Codable {
    let data: [messageModel]?
    let links: Links?
    let meta: Meta?
}
struct messageModel : Codable {
    let id : Int?
    let message : String?
    let is_mine : Bool?
    let sender : Sender?
    let is_read : Bool?
    let read_at : String?
    let created_at : String?
    let created_date : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case message = "message"
        case is_mine = "is_mine"
        case sender = "sender"
        case is_read = "is_read"
        case read_at = "read_at"
        case created_at = "created_at"
        case created_date = "created_date"
    }

   

}
struct Sender : Codable {
    let id : Int?
    let name : String?
    let avatar : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case avatar = "avatar"
    }


}
