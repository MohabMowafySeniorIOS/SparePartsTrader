//
//  NotificationMode.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/15/25.
//

import Foundation
struct NotificationModel : Codable {
    let data : [Notification]?
    let links : Links?
    let meta : Meta?
    let message : String?
    let status : String?
    let unread_count : Int?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case links = "links"
        case meta = "meta"
        case message = "message"
        case status = "status"
        case unread_count = "unread_count"
    }

   

}

struct Notification: Identifiable, Codable {
    let id : String?
    let icon : String?
    let created_at : String?
    let read_at : String?
    let is_readed : Bool?
    let created_time : String?
    let type : String?
    let title : String?
    let body : String?
    let notify_id : Int?
    let sender_id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case icon = "icon"
        case created_at = "created_at"
        case read_at = "read_at"
        case is_readed = "is_readed"
        case created_time = "created_time"
        case type = "type"
        case title = "title"
        case body = "body"
        case notify_id = "notify_id"
        case sender_id = "sender_id"
    }

   
}
