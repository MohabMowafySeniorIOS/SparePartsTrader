//
//  ResendOTPModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/6/25.
//

import Foundation
struct ResendOTPModel: Codable {
    
    let phone: String?
    let otp: String?
   
    enum CodingKeys: String, CodingKey {
      
        case phone
        case otp = "otp"
      
    }
}
