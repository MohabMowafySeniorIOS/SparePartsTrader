//
//  Date+.swift
//  MyAuctions
//
//  Created by Mohab on 15/06/2025.
//

import Foundation
extension DateFormatter {
    static let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}
