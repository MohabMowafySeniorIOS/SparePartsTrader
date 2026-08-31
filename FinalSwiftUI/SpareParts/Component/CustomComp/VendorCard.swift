//
//  VendorCard.swift
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//

import Foundation
import SwiftUI

struct VendorCard: View {
    
    @State var startSize: CGFloat = 25
    @State var paddingValue: CGFloat = 10
    
    var vendorsModel: Trader?
    var orderNow: ()->Void
    var favouriteAction: ()->Void
    
    var body: some View {
        VStack(alignment: .center,spacing: 15){
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    Text(vendorsModel?.tradeName ?? "")
                        .font(.custom(AppFont.bold.rawValue, size: 16))
                    Spacer()
                    Text(vendorsModel?.country?.name ?? "")
                        .font(.custom(AppFont.Regular.rawValue, size: 16))
                    Spacer()
                    Text(vendorsModel?.city?.name ?? "")
                        .font(.custom(AppFont.Regular.rawValue, size: 16))
                }
                Spacer()
                RemoteImageView(imageUrl: vendorsModel?.logo?.path ?? "")
                    .scaledToFill()
                    .frame(width: 70, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.SecondaryColor, lineWidth: 1)
                    )
            }
            HStack{
                Image(systemName: "heart.fill")
                    .foregroundStyle( vendorsModel?.isFavorite == true ? Color.CRed : Color.CGray2)
                    .font(.system(size: 30))
                    .onTapGesture {
                        favouriteAction()
                    }

                CustomStarRatingView(rating: vendorsModel?.ratingAvg ?? 0.0, startSize: $startSize, paddingValue: $paddingValue)
            }
            Button {
                orderNow()
            } label: {
                Text("order_now".localized)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.MainColor)
                    .cornerRadius(20)
            }
            .buttonStyle(.plain)

        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .fill(Color.SecondaryColor)
        )
        .padding(1)
        .padding(.trailing,7)
    }
}
#Preview(body: {
//    VendorCard(verndors: 3)
})

protocol VendorDisplayable {
    var id: Int? { get }
    var name: String? { get }
    var logo: Logo? { get }
    var cityName: String? { get }
    var city: City? { get }
    var rating: Double? { get }
}


struct VendorGridCard: View {
    var orderNow: ()->Void
    var vendorsModel: Trader?
    var favouriteAction: ()->Void
    @State private var startSize: CGFloat = 18
    @State private var paddingValue: CGFloat = 4
    @State private var navToOrderNow: Bool = false
    

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            // MARK: - Image
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(vendorsModel?.tradeName ?? "")
                        .font(.custom(AppFont.bold.rawValue, size: 16))
                    if vendorsModel?.city != nil {
                        Text(vendorsModel?.country?.name ?? "")
                            .font(.custom(AppFont.Regular.rawValue, size: 16))
                        
                        Text(vendorsModel?.city?.name ?? "")
                            .font(.custom(AppFont.Regular.rawValue, size: 16))
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(Color.SecondaryColor)
                .minimumScaleFactor(0.3)
                Spacer()
                
                RemoteImageView(imageUrl: vendorsModel?.logo?.path ?? "")
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.SecondaryColor, lineWidth: 1)
                    )
                    .shadow(radius: 2)
            }
            
            // MARK: - Rating + Favourite
            HStack(spacing: 6) {
                Image(systemName: "heart.fill")
                    .foregroundStyle( vendorsModel?.isFavorite == true ? Color.CRed : Color.CGray2)
                    .font(.system(size: 18))
                    .onTapGesture {
                   favouriteAction()
                    }

                CustomStarRatingView(
                    rating: vendorsModel?.ratingAvg ?? 0.0,
                    startSize: $startSize,
                    paddingValue: $paddingValue
                )
            }
            
            // MARK: - Button
            Button {
                orderNow()
            } label: {
                Text("order_now".localized)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(Color.MainColor)
                    .cornerRadius(20)
            }
            .buttonStyle(.plain)

        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.SecondaryColor, lineWidth: 1)
        )
        .padding(.horizontal, 4)
    }
}
