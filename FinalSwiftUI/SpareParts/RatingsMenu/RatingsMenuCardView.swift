//
//  RatingsMenuCardView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import SwiftUI

struct RatingsMenuCardView: View {
    var body: some View {
        VStack(spacing: 10){
            Text("1")
                .font(addFont(fontType: .bold, size: 15))
                .padding(.horizontal,5)
                .background(RoundedRectangle(cornerRadius: 0).stroke(style: StrokeStyle()))
            
            HStack(alignment:.top,spacing: 10){
                VStack(alignment: .leading,spacing: 10){
                        Text("date_and_time")
                            .font(addFont(fontType: .bold, size: 15))
                            .foregroundStyle(Color.MainColor)
                    .padding(.leading,5)
                    
                        Text("user_name")
                            .font(addFont(fontType: .bold, size: 15))
                            .foregroundStyle(Color.MainColor)
                    .padding(.leading,5)
                    
                        Text("rating")
                            .font(addFont(fontType: .bold, size: 15))
                            .foregroundStyle(Color.MainColor)
                    .padding(.leading,5)
                    
                        Text("rating_text")
                            .font(addFont(fontType: .bold, size: 15))
                            .foregroundStyle(Color.MainColor)
                    .padding(.leading,5)
                    
                }
                
                //second column
                
                VStack(alignment: .leading,spacing: 10){
                    HStack(spacing:20){
                        Text("9/8/9988")
                            .font(addFont(fontType: .bold, size: 15))
                            .foregroundStyle(Color.MainColor)
                        
                        Text("9/8/9988")
                            .font(addFont(fontType: .bold, size: 15))
                            .foregroundStyle(Color.MainColor)
                    }
                    .padding(.leading,5)
                    
                        Text("user_name")
                            .font(addFont(fontType: .bold, size: 15))
                            .foregroundStyle(Color.MainColor)
                    .padding(.leading,5)
                    
                    HStack(spacing:10){
                        Text("4.5")
                            .font(addFont(fontType: .bold, size: 15))
                            .foregroundStyle(Color.MainColor)
                        
                        CustomStarRatingView(rating: 4, startSize: .constant(15), paddingValue: .constant(1))
                    }
                    .padding(.leading,5)
                }
                
                Spacer()
            }
            HStack{
                Text("we mark a class ObservableObject so that when a @published var state changes inside the class the view that has an object from that class updates automatically ")
                    .foregroundStyle(Color.MainColor)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity,maxHeight: 300)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle())
                
        )
        .padding(.horizontal,10)
        .padding(5)
    }
}

#Preview {
    RatingsMenuCardView()
}
