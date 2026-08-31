//
//  AddressModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/26/25.
//

import Foundation
struct AddressData : Codable, Equatable, Hashable {
    let id : Int?
    let title : String?
    let latitude : Double?
    let longitude : Double?
    let is_default : Bool?
    let address_text : String?
    let description : String?
    let created_at : String?
    var isSelected: Bool = false
    mutating func setisSelected(isSelected: Bool){
        self.isSelected = isSelected
     }

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case latitude = "latitude"
        case longitude = "longitude"
        case is_default = "is_default"
        case address_text = "address_text"
        case description = "description"
        case created_at = "created_at"
    }
}
