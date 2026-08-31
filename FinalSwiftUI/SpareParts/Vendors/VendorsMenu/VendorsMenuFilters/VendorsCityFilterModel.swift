//
//  VendorsCityFilterModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import Foundation

struct VendorsCityFilterModel: Codable,Identifiable {
    var id = UUID()
    var city: String
    var isSelected: Bool
}
