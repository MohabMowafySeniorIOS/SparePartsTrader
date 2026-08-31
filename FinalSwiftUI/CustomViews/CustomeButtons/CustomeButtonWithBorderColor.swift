//
//  CustomeButtonWithBorderColor.swift
//  FinalSwiftUI
//
//  Created by Mohab on 15/05/2025.
//

import SwiftUI


import SwiftUI
struct CustomeButtonWithBorderColor: View {
    var title: String
    var action: () -> Void // Action closure
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action : action) {
                Spacer()
                Text(title.localized)
                    .font(.custom(AppFont.bold.rawValue, size: 16))
                    .foregroundColor(.MainColor)
                //.frame(width:.infinity,height: 48)
                Spacer()
                
                
                
                
            }
            .frame(maxWidth:.infinity,minHeight: 48)
            .cornerRadius(24)
            .foregroundColor(Color.MainColor)
            .padding(0)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.MainColor, lineWidth: 1)
            )
            
        }
        
    }
}















