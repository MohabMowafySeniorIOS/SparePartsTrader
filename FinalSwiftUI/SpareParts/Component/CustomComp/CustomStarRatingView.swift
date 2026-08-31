//
//  CustomRating.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//

import SwiftUI

struct CustomStarRatingView: View {
    var rating: Double // Changed to Double for half-star support
    let maxRating: Int = 5   // Maximum rating
    @Binding var startSize: CGFloat
    @Binding var paddingValue: CGFloat
    
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { index in
                let starType = starTypeFor(index: index)
                
                Image(systemName: starType)
                    .font(.system(size: startSize))
                    .frame(maxWidth: 12, maxHeight: 12)
                    .foregroundColor(starColorFor(index: index))
                    .padding(paddingValue)
            }
        }
    }

    private func starTypeFor(index: Int) -> String {
        if Double(index) <= rating {
            return "star.fill"
        }
        else if Double(index) - 0.5 <= rating {
            return "star.leadinghalf.filled"
        }
        else {
            return "star"
        }
    }
    
    private func starColorFor(index: Int) -> Color {
        if Double(index) <= rating {
            return .yellow
        } else if Double(index) - 0.5 <= rating {
            return .yellow
        } else {
            return .gray
        }
    }
}

#Preview(body: {
    CustomStarRatingView(rating: 3, startSize: .constant(10), paddingValue: .constant(10))
})
