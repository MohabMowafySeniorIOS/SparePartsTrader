//
//  CountryAndCitiesModel.swift
//  SpareParts
//
//  Created by Mohab on 16/02/2026.
//

import Foundation
struct CountryAndCitiesModel: Identifiable {
    var id = UUID()
    var country: CountryData?
    var cities: [CityData]?
    
    mutating func setCountry(Model: CountryData){
        self.country = Model
    }
    
    mutating func setCity(Model: CityData){
        self.cities?.append(Model)
    }
    
    mutating func remveCity(Model: CityData) {
        self.cities?.removeAll { $0.id == Model.id }
    }
}
