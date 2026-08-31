//
//  VendorsCountryFilterModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import Foundation
struct VendorsCountryFilterModel: Codable,Identifiable {
    var id = UUID()
    var city: String
    var isSelected: Bool
}
