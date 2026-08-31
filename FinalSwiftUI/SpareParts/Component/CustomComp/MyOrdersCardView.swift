//
//  MyOrdersCardView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 18/07/2025.
//

import SwiftUI
struct MyOrdersCardView: View {
    @State var ordersData: Order
    var orderIndex: Int? = nil
    var selectOrder: ()->Void
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    Text(ordersData.orderType?.label ?? "")
                        .font(addFont(fontType: .bold, size: 15))
                        .foregroundStyle(Color.CBlack)

                    if let orderIndex {
                        Text("\(orderIndex)")
                            .font(addFont(fontType: .bold, size: 13))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(Color.MainColor))
                    }
                }

                Spacer()

                Text(ordersData.status?.label ?? "")
                    .font(addFont(fontType: .bold, size: 13))
                    .foregroundStyle(Color.MainColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(Color.MainColor.opacity(0.12))
                    )
            }

            if let orderNumber = ordersData.orderNumber, !orderNumber.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "number")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.MainColor)
                    Text(orderNumber)
                        .font(addFont(fontType: .Regular, size: 13))
                        .foregroundStyle(Color.CGray2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Spacer()
                }
            }

            Divider()

            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.MainColor)
                    Text(ordersData.createdAt ?? "")
                        .font(addFont(fontType: .Regular, size: 13))
                        .foregroundStyle(Color.CGray2)
                }

                Spacer()

                Text("\("Count".localized): \(ordersData.itemsCount ?? 0)")
                    .font(addFont(fontType: .bold, size: 14))
                    .foregroundStyle(Color.CBlack)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        .onTapGesture {
            selectOrder()
        }
    }
}
