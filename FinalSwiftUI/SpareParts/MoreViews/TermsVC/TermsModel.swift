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

        case title = "title"
        case content = "content"
     
    }

   
}


