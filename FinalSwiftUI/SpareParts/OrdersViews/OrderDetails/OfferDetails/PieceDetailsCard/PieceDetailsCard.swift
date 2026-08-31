//
//  PieceDetailsCard.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//
import SwiftUI

struct PieceDetailsCard: View {
    var offer: OfferItem
    var body: some View {
        HStack(){
            VStack(alignment: .leading,spacing: 10){
               
                Text("Piece Name".localized)
                    .foregroundStyle(Color.MainColor)
                    .font(addFont(fontType: .Medium, size: 18))
                
                Text("Piece Number".localized)
                    .foregroundStyle(Color.MainColor)
                    .font(addFont(fontType: .Medium, size: 18))
                
//                Text("Piece Type".localized)
//                    .foregroundStyle(.main)
//                    .font(addFont(fontType: .Medium, size: 18))
                
                Text("Count".localized)
                    .foregroundStyle(Color.MainColor)
                    .font(addFont(fontType: .Medium, size: 18))
                
                Text("Price (incl. tax)".localized)
                    .foregroundStyle(Color.MainColor)
                    .font(addFont(fontType: .Medium, size: 18))
                
            }
            Spacer()
            VStack(alignment: .leading,spacing: 10){
                
                Text(offer.orderItem?.partName ?? "")
                    .foregroundStyle(Color.CGray1)
                
                Text(offer.orderItem?.partNumber ?? "")
                    .foregroundStyle(Color.CGray1)
                
               // Text(offer.orderItem. ?? 0)
                //    .foregroundStyle(Color.CGray1)
                
                Text("\(offer.orderItem?.quantity ?? 0)")
                    .foregroundStyle(Color.CGray1)
                
                Text("\(offer.price ?? 0.0)")
                    .foregroundStyle(Color.CGray1)
                
            }
            .padding(.trailing)
            
        }
        .padding()
        .frame(height:200)
        .background(RoundedRectangle(cornerRadius: 10).stroke(style: StrokeStyle())
            .fill(Color.MainColor))
    }
}
