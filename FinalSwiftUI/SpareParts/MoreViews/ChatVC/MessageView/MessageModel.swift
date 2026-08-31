//
//  MessageModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 7/5/25.
//


import Foundation
struct MessagesModel : Codable , Identifiable {
    var id = UUID()
    let chatId : Int?
    let order : Order?
    let other_party : Other_party?
    let last_message : Last_message?
    let unread_count : Int?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case chatId = "id"
        case order = "order"
        case other_party = "other_party"
        case last_message = "last_message"
        case unread_count = "unread_count"
        case updated_at = "updated_at"
    }

   
}
struct Last_message : Codable {
    let message : String?
    let message_type : String?
    let is_mine : Bool?
    let created_at : String?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case message_type = "message_type"
        case is_mine = "is_mine"
        case created_at = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        message_type = try values.decodeIfPresent(String.self, forKey: .message_type)
        is_mine = try values.decodeIfPresent(Bool.self, forKey: .is_mine)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }

}

import Foundation
struct Other_party : Codable {
    let id : Int?
    let name : String?
    let avatar : String?
    let type : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case avatar = "avatar"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }

}
