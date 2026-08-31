//
//  NotificationCountModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/28/25.
//

import Foundation

// MARK: - UnreadNotificationsData
struct UnreadNotificationsData: Codable {
    let unreadCount: Int?

    enum CodingKeys: String, CodingKey {
        case unreadCount = "unread_count"
    }
}
