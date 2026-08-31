//
//  WalletVendorVC.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import SwiftUI

struct WalletView: View {
    
    @ObservedObject private var viewModel: VendorWalletViewModel
    
    init(viewModel: VendorWalletViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Header
            AppHeaderView(Title: "wallet.title".localized) {
                viewModel.coordinator.disMiss()
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    BalanceSection()
                    
                    WithdrawButton()
                    
                    TabsSection()
                    
                    TableView(items: viewModel.items)
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}


// MARK: Balance Section
struct BalanceSection: View {
    var body: some View {
        VStack(spacing: 16) {
            
            BalanceRow(title: "wallet.total_earnings".localized, value: "100000 ريال")
            BalanceRow(title: "wallet.current_balance".localized, value: "100000 ريال")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct BalanceRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(value)
                .font(.headline)
            
            Spacer()
            
            Text(LocalizedStringKey(title))
                .foregroundColor(.secondary)
        }
    }
}


// MARK: Withdraw Button
struct WithdrawButton: View {
    var body: some View {
        Button(action: {}) {
            Text("wallet.withdraw_request".localized)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(30)
        }
    }
}


// MARK: Tabs
struct TabsSection: View {
    var body: some View {
        HStack {
            Text("wallet.withdrawals_tab".localized)
                .font(.headline)
            
            Spacer()
            
            Text("wallet.additions_tab".localized)
                .foregroundColor(.blue)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.blue)
                        .offset(y: 12),
                    alignment: .bottom
                )
        }
    }
}


// MARK: Table
struct TableView: View {
    let items: [WithdrawalItem]
    
    var body: some View {
        VStack(spacing: 0) {
            
            TableHeader()
            
            ForEach(items) { item in
                TableRow(item: item)
                Divider()
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.5))
        )
    }
}


// MARK: Header
struct TableHeader: View {
    var body: some View {
        HStack {
            TableCell(text: "wallet.col_index".localized)
            TableCell(text: "wallet.col_reference".localized)
            TableCell(text: "wallet.col_request".localized)
            TableCell(text: "wallet.col_amount".localized)
            TableCell(text: "wallet.col_date".localized)
            TableCell(text: "wallet.col_time".localized)
        }
        .background(Color.gray.opacity(0.15))
    }
}


// MARK: Row
struct TableRow: View {
    let item: WithdrawalItem
    
    var body: some View {
        HStack {
            TableCell(text: "\(item.index)")
            TableCell(text: item.referenceNumber)
            TableCell(text: item.requestNumber)
            TableCell(text: item.amount)
            TableCell(text: item.date)
            TableCell(text: item.time)
        }
    }
}
extension String {
    
    func dateToString() -> String {
       
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // formatter للشكل النهائي
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = .current   // يعرض حسب توقيت الموبايل

        if let date = isoFormatter.date(from: self) {
            let finalString = outputFormatter.string(from: date)
           return finalString
        }
        return ""
    }
}

// MARK: Cell
struct TableCell: View {
    let text: String
    
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.caption)
            .frame(maxWidth: .infinity)
            .padding(8)
    }
}
