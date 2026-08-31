//
//  HorizontalImageScroller.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import SwiftUI


struct HorizontalImageScroller: View {
    let images: [VendorImage]
    @Binding var currentImage: String?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(images, id: \.id) { image in
                        RemoteImageView(imageUrl: image.path ?? "")
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.SecondaryColor, lineWidth: 2)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture {
                                    currentImage = image.path
                                }
                        
                        .frame(width: 100, height: 100)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
