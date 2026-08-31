//
//  سثففهرلؤخيثم.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/6/25.
//

import Foundation
import Foundation


struct SettingsData: Codable {
    let settings: Settings?
}

struct Settings: Codable {
    let min_bid_increment: String?
    let customer_support_phone: String?
    let customer_support_email: String?
}
