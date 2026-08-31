//
//  TransActionCardView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/28/25.
//

import Foundation
import SwiftUI

typealias onTap = ()->Void
struct WalletBlockItem: View {

    var item : TransactionItem?
    var itemIndex: Int? = nil
    @Binding var selectedTab: walletTab
    var banckDetailsTap: onTap
    var imageTap: onTap

    var body: some View {

        VStack(alignment:.leading, spacing: 14) {
            if let itemIndex {
                Text("\(itemIndex)")
                    .font(addFont(fontType: .bold, size: 13))
                    .foregroundStyle(.white)
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(Color.MainColor))
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            HStack(alignment: .top, spacing: 16) {

                VStack(alignment:.leading,spacing:10){
                    WalletCardItem(title: "reference_number", value: "\(item?.id ?? 0)")
                    WalletCardItem(title: "transaction_type", value: item?.status_label ?? "")
                    WalletCardItem(title: "Order Number", value: item?.order_number ?? "")
                }

                Spacer(minLength: 16)

                VStack(alignment:.leading,spacing:10){
                    WalletCardItem(title: "amount", value: item?.amount ?? "")
                    WalletCardItem(title: "transaction_date", value: (item?.created_at ?? "").dateToString())
                    WalletCardItem(title: "transaction_time", value: (item?.created_at ?? "").dateToString())
                }
            }

            if selectedTab == .withDrawRequest {
                buttonSection
            }

        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    private var buttonSection: some View {
        HStack {
            ContentButtonView(title: "View bank account details".localized) {
                banckDetailsTap()
            }
            if (item?.transfer_image?.count ?? 0) > 0 {
                CustomeButtonWithBorderColor(title: "View conversion image".localized) {
                    imageTap()
                }
            }


        }
        .padding(.top, 4)

    }

}
struct WalletCardItem: View {
    var title: String
    var value: String
    var body: some View {
        HStack(spacing: 6) {
            Text("\(title)".localized)
                .font(addFont(fontType: .Regular, size: 13))
                .foregroundStyle(Color.CGray2)
            Text(value)
                .font(addFont(fontType: .bold, size: 14))
                .foregroundStyle(Color.CBlack)
        }
    }
}

struct WalletUsageBlockItem: View {
    
    var productNumber: String
    var referenceNumber: String
    var productName: String
    var moneyAmount: String
    var time: String
    var bgColor: Color
    
    var body: some View {
        
        VStack(alignment:.leading, spacing: 10) {
            Text(productNumber)
                .foregroundStyle(Color.CBlack)
                .padding(.vertical, 2)
                .padding(.horizontal, 7)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(style: StrokeStyle())
                        .fill(Color.CBlack)
                )
                .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(alignment:.leading){
                HStack(spacing:16){
                    
                    VStack(alignment:.leading,spacing:10){
                        WalletCardItem(title: "reference_number", value: referenceNumber)
                        Spacer()
                        WalletCardItem(title: "money_amount", value: moneyAmount)
                        
                        Spacer()
                    }
                    
                    VStack(alignment:.leading,spacing:10){
                        WalletCardItem(title: "product_name", value: productName)
                        Spacer()
                        HStack {
                            Image(systemName: "clock")
                                .foregroundStyle(Color.MainColor)
                            
                            Text(time)
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding(10)
            
        }
        .padding()
        .background(bgColor)
    }
    
    struct WalletCardItem: View {
        var title: String
        var value: String
        var body: some View {
            HStack {
                
                Text("\(title)".localized)
                Text(value)
                
            }
        }
    }
}
