//
//  OffersCardView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//

import SwiftUI

struct OffersCardView: View {
    var canMessage: Bool
    let part: OffersCardModel
    let buttonTitle: String
    let onShowPictures: () -> Void
    let onMessage: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            OfferInfoRow(icon: "name", text: part.name)
            OfferInfoRow(icon: "city", text: part.country)
            OfferInfoRow(icon: "Country", text: part.city)
            OfferInfoRow(icon: "mouny", text: part.price)

            HStack {
                Button(action: onShowPictures) {
                    Text(buttonTitle.localized)
                        .font(addFont(fontType: .Medium, size: 14))
                        .foregroundStyle(Color.CWhite)
                        .frame(maxWidth: .infinity, minHeight: 36)
                        .background(Color.MainColor)
                        .clipShape(Capsule())
                }
                if canMessage {
                    Button(action: onMessage) {
                        Image(systemName: "ellipsis.message.fill")
                            .foregroundStyle(Color.MainColor)
                            .font(.system(size: 22))
                    }
                }
            }
        }
        .padding()
        .frame(width: 240)
        .foregroundStyle(Color.white)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .stroke(Color.SecondaryColor)
        )
    }
}

struct OfferInfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(icon)
                .resizable()
                .foregroundStyle(Color.SecondaryColor)
                .frame(width: 24, height: 24)

            Text(text)
                .foregroundStyle(Color.CGray1)
                .font(addFont(fontType: .Medium, size: 16))

            Spacer()
        }
    }
}

#Preview {
    OffersCardView(
        canMessage: true, part: .init(
            name: "Someone",
            country: "Saudi Arabia",
            city: "Riyadh",
            price: "5000 SAR"
        ), buttonTitle: "show images",
        onShowPictures: {
            print("Show pictures tapped")
        }, onMessage: {
            print("Message tapped")
        }
    )
}
