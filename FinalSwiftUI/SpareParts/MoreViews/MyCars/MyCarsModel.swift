//
//  MyCarsModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/12/25.
//

import Foundation

struct CarsData : Codable, Equatable, Hashable {
    let id : Int?
    var category: categoryModel?
    var brand : categoryModel?
    var model : categoryModel?
    var year : Int?
    let chassis_number : String?
    let is_default : Bool?
    let full_name : String?
    let created_at : String?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case category = "category"
        case brand = "brand"
        case model = "model"
        case year = "year"
        case chassis_number = "chassis_number"
        case is_default = "is_default"
        case full_name = "full_name"
        case created_at = "created_at"
    }
    
   mutating func setCategory(category: categoryModel?){
       self.category = category
    }
    
    mutating func setBrand(brand: categoryModel?){
        self.brand = brand
     }
    
    mutating func setModel(model: categoryModel?){
        self.model = model
     }
    
    mutating func setYear(year: Int?){
        self.year = year
     }
    
    mutating func setisSelected(isSelected: Bool){
        self.isSelected = isSelected
     }
    
    
}

struct categoryModel : Codable, Equatable, Hashable {
    let id : Int?
    let name : String?
    var isChoosen: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    mutating func toggleIsChoosen() {
        self.isChoosen.toggle()
    }
}
