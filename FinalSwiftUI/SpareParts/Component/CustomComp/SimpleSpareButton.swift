//
//  SimpleSpareButton.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 16/07/2025.
//

import SwiftUI
struct SimpleSpareButton: View {
    
    var buttonTitle: String
    var action: () -> Void
    var widthValue: CGFloat
    var heightValue: CGFloat

    var body: some View {
        Button {
            action()
        } label: {
            Text(buttonTitle.localized)
                .font(.custom(AppFont.bold.rawValue, size: 16))
                .foregroundStyle(Color.CWhite)
                .frame(width: widthValue, height: heightValue)
                .background(
                    Color.MainColor
                        .cornerRadius(20)
                )
        }

    }
}
