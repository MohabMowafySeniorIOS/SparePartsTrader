//
//  PlainAppHeaderView.swift
//  MyAuctions
//
//  Created by Mohab on 08/07/2025.
//
import SwiftUI


struct PlainAppHeaderView: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text(title.localized)
                .foregroundStyle(Color.CWhite)
                .font(.system(size: 20))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.MainColor)
    }
}
