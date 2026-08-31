//
//  withDrawModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/27/25.
//

import Foundation
import Foundation



// MARK: - WithdrawalData
struct WithdrawalData: Codable {
    let transaction: WithdrawalTransaction?
    let newBalance: String?

    enum CodingKeys: String, CodingKey {
        case transaction
        case newBalance = "new_balance"
    }
}

// MARK: - WithdrawalTransaction
struct WithdrawalTransaction: Codable {
    let userID: Int?
    let amount: String?
    let type: String?
    let referenceID: String?
    let description: String?
    let metadata: WithdrawalMetadata?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case amount
        case type
        case referenceID = "reference_id"
        case description
        case metadata
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

// MARK: - WithdrawalMetadata
struct WithdrawalMetadata: Codable {
    let bankAccount: String?
    let bankName: String?
    let accountHolder: String?

    enum CodingKeys: String, CodingKey {
        case bankAccount = "bank_account"
        case bankName = "bank_name"
        case accountHolder = "account_holder"
    }
}
