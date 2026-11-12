//
//  TermsModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/6/25.
//


import Foundation

struct TermsResponse: Codable {
    let title : String?
    let content : String?
    enum CodingKeys: String, CodingKey {
        case title, content
        case titleAr = "title_ar"
        case titleEn = "title_en"
        case contentAr = "content_ar"
        case contentEn = "content_en"
        case description
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
            ?? values.decodeIfPresent(String.self, forKey: .titleAr)
            ?? values.decodeIfPresent(String.self, forKey: .titleEn)
        content = try values.decodeIfPresent(String.self, forKey: .content)
            ?? values.decodeIfPresent(String.self, forKey: .contentAr)
            ?? values.decodeIfPresent(String.self, forKey: .contentEn)
            ?? values.decodeIfPresent(String.self, forKey: .description)
    }

    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encodeIfPresent(title, forKey: .title)
        try values.encodeIfPresent(content, forKey: .content)
    }
}


