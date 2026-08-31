//
//  VendorCard.swift
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//

import Foundation
import SwiftUI

struct VendorCardModel {
    let name: String
    let image: String
    let country: String
    let city: String
    let location: String
    let rating: Double
    let isfavorite: Bool
}

struct VendorCardWithLocation: View {
    
    let vendor: Trader
    @State var startSize: CGFloat = 15
    @State var paddingValue: CGFloat = 2
    var orderNow: ()->Void
    var openLocation: ()->Void
    var pressFavourite: ()->Void
    
    var body: some View {
        VStack{
            VStack(alignment: .leading,spacing: 10){
                
                VStack(alignment: .leading,spacing: 10){
                    HStack {
                        Text(vendor.tradeName ?? "")
                            .font(addFont(fontType: .bold, size: 14))
                          
                        Spacer()
                        RemoteImageView(imageUrl: vendor.logo?.path ?? "")
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.SecondaryColor, lineWidth: 1)
                            )
                            .shadow(radius: 2)
                    }
                    
                    
                    Text(vendor.country?.name ?? "")
                        .font(addFont(fontType: .Regular, size: 15))
                    Text(vendor.city?.name ?? "")
                        .font(addFont(fontType: .Regular, size: 15))
                }
                
                HStack{
                    Text("distance_between_vendor_customer".localized)
                        .foregroundStyle(Color.MainColor)
                        .multilineTextAlignment(.leading)
                        .font(addFont(fontType: .bold, size: 15))
                    Spacer()
                    Image.darkLocation
                }
                .onTapGesture {
                    openLocation()
                }
                
                HStack{
                    Image(systemName: "heart.fill")
                        .foregroundStyle(vendor.isFavorite ? Color.CRed : Color.CGray2)
                        .font(.system(size: 15))
                        .onTapGesture {
                            pressFavourite()
                        }
                    
                    CustomStarRatingView(rating: vendor.ratingAvg ?? 0.0, startSize: $startSize, paddingValue: $paddingValue)
                    Spacer()
                }
                
            }
            SimpleSpareButton(buttonTitle: "order_now".localized, action: {
                orderNow()
            }, widthValue: 150, heightValue: 32)
            .padding(.top, 5)
            
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .fill(Color.CBlack)
        )
        .padding(1)
        
    }
}
