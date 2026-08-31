//
//  HomeImageSlider.swift
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//
import SwiftUI

struct HomeImageSlider: View {
    
    @Binding var tabSelection: Int
     var images: [Banner]
    
    var body: some View {
        TabView(selection: $tabSelection) {
            ForEach(Array(images.enumerated()), id: \.element.id) { index, banner in
                RemoteImageView(imageUrl: banner.image?.path ?? "")
                    .frame(height:180)
                    .cornerRadius(15)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height:180)
        
        HStack(spacing: 8) {
            ForEach(0..<images.count, id: \.self) { index in
                Circle()
                    .fill(index == tabSelection ? Color.MainColor : .clear)
                    .frame(width: 12, height: 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle())
                        .fill(Color.CBlack.opacity(0.7))
                    )
            }
        }
    }
}
