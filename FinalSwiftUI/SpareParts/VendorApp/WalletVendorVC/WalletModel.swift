//
//  WalletModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation
struct WithdrawalItem: Identifiable {
    let id = UUID()
    let index: Int
    let referenceNumber: String
    let requestNumber: String
    let amount: String
    let date: String
    let time: String
}
