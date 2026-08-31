//
//  TitleLabel.swift
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//
import SwiftUI

struct TitleLabel: View {
    var title: String
    var body: some View {
        HStack{
            Text(title.localized)
                .foregroundStyle(Color.SecondaryColor)
                .font(addFont(fontType: .bold, size: 16))
            Spacer()
        }
    }
}
