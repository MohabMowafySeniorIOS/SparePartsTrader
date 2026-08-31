//
//  FAQModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/6/25.
//

import Foundation

struct FAQ: Identifiable, Codable {
    let id: Int?
    let question: String?
    let answer: String?
    let order: Int?
    var isExpanded: Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case question = "question"
        case answer = "answer"
        case order = "order"
    }
   mutating func togle() {
        isExpanded.toggle()
    }


}
