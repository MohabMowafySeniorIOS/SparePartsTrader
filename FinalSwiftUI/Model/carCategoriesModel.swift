//
//  carCategoriesModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/6/25.
//

import Foundation
import Foundation

struct CarTypeResponse: Codable {
    let data: [CarType]?
}

struct CarType: Codable {
    let id: Int?
    let name: String?
    let image: String?
}


