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
        case id, question, answer, order
        case questionAr = "question_ar"
        case questionEn = "question_en"
        case answerAr = "answer_ar"
        case answerEn = "answer_en"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        question = try values.decodeIfPresent(String.self, forKey: .question)
            ?? values.decodeIfPresent(String.self, forKey: .questionAr)
            ?? values.decodeIfPresent(String.self, forKey: .questionEn)
        answer = try values.decodeIfPresent(String.self, forKey: .answer)
            ?? values.decodeIfPresent(String.self, forKey: .answerAr)
            ?? values.decodeIfPresent(String.self, forKey: .answerEn)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
    }

    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encodeIfPresent(id, forKey: .id)
        try values.encodeIfPresent(question, forKey: .question)
        try values.encodeIfPresent(answer, forKey: .answer)
        try values.encodeIfPresent(order, forKey: .order)
    }

   mutating func togle() {
        isExpanded.toggle()
    }


}
