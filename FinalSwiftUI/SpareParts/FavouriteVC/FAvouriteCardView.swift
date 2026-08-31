//
//  FAvouriteCardView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/27/25.
//

import SwiftUI

struct FavouritesCard: View {
    var item : Listing?
//    var productName: String
//    var productPrice: String
//    var productlocation: String
//    var productVendor: String
//    var vendorImage: Image
//    var productDate: String
//    var productImage: Image
//    var isFavourite: Bool
//    var action: () -> Void
//    var imageAction: () -> Void

    var body: some View {
        HStack {
            VStack {
                ZStack(alignment: .topTrailing) {
                    RemoteImageView(imageUrl: item?.mainImage ?? "")

                       

                    Group{
                        if item?.isFavourite == true {
                            Image("FavouriteBtn")
                                .padding(7)
                        }else{
                            Image.unFavouriteIcon
                                .padding(7)
                        }
                    }
                  
                   
                }
                Text(item?.publicationDate ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            Spacer()

            VStack(alignment: .trailing, spacing: 10) {
                Text(item?.title ?? "")

                Text(item?.price ?? "")

                Text(item?.city ?? "")

                HStack {
                    Text("productVendor")
                        .font(addFont(fontType: .bold, size: 15))

                    RemoteImageView(imageUrl: item?.mainImage ?? "")
                        .frame(width: 24,height: 24)
                }
            }

        }.padding()
    }
}

import SwiftUI

struct RemoteImageView: View {
    let imageUrl: String

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView() // show a loading spinner
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Image(systemName: "photo") // fallback image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
       //.frame(width: 200, height: 200)
        .clipped()
        .cornerRadius(10)
    }
}
