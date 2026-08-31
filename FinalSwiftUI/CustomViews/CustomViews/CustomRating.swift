//
//  CustomRating.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    let maxRating: Int = 5
    @Binding var startSize: CGFloat
    @Binding var paddingValue: CGFloat
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: startSize))
                    .frame(maxWidth: 12,maxHeight: 12)
                    .foregroundColor(star <= rating ? .yellow : .gray)
                    .padding(paddingValue)
                    .onTapGesture {
                        rating = star
                    }
                    .font(.largeTitle)
            }
        }
    }
}

struct RatingExample: View {
    @State private var userRating: Int = 3
    
    var body: some View {
        VStack {
            StarRatingView(rating: $userRating, startSize: .constant(20), paddingValue: .constant(16))
        }
        .padding()
    }
}

struct RatingExample_Previews: PreviewProvider {
    static var previews: some View {
        RatingExample()
    }
}
