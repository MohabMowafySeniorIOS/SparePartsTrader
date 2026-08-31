//
//  CarBrandModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/6/25.
//

import Foundation
struct CarBrandResponse: Codable {
    let data: [CarType]?
}

struct CarBrand: Codable {
    let id: Int?
    let name: String?
    
}

