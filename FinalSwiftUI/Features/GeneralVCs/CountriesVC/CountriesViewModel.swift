//
//  CountriesViewModel.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 16/01/2025.
//

import Foundation
struct CountriesData : Codable {
    let id : Int?
    let name : String?
    let flag : String?
    let country_code : String?
    let verify_via : String?
    let is_default : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case flag = "flag"
        case country_code = "country_code"
        case verify_via = "verify_via"
        case is_default = "is_default"
    }
}
