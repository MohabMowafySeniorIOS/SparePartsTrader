//
//  TotalCostCardView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//
import SwiftUI

struct TotalCostCardView: View {
    var Model: Offer
    var body: some View {
        HStack(){
            VStack(alignment: .leading,spacing: 10){
               
                Text("Total Price".localized)
                    .foregroundStyle(Color.MainColor)
                    .font(addFont(fontType: .Medium, size: 18))
                
                Text("Charge Price".localized)
                    .foregroundStyle(Color.MainColor)
                    .font(addFont(fontType: .Medium, size: 18))
                
                Text("Total Cost".localized)
                    .foregroundStyle(Color.MainColor)
                    .font(addFont(fontType: .Medium, size: 18))
                
            }
            Spacer()
            VStack(alignment: .leading,spacing: 10){
                
                Text("\(Model.subtotal ?? 0.0)")
                    .foregroundStyle(Color.CGray1)
                
                Text("\(Model.shippingCost ?? 0.0)")
                    .foregroundStyle(Color.CGray1)
                
                Text("\(Model.totalAmount ?? 0.0)")
                    .foregroundStyle(Color.CGray1)
                
            }
            .padding(.trailing)
            
        }
        .padding()
        .frame(height:120)
        .background(RoundedRectangle(cornerRadius: 10).stroke(style: StrokeStyle())
            .fill(Color.MainColor))
    }
}
