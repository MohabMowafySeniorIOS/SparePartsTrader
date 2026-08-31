//
//  CountryModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/24/25.
//

import Foundation
struct CountryData: Codable , Identifiable, Hashable {
    var id: Int?
    let name: String?
    let phone_code: String?
    let phone_limit: Int?
   

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case phone_code = "phone_code"
        case phone_limit = "phone_limit"
       
    }
}

struct CityData: Codable, Identifiable, Hashable {
    let id: Int?
    let name: String?
    var isSelected: Bool = false
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
      
    }
    
    mutating func toggleSelected() {
        isSelected = !isSelected
    }
}
