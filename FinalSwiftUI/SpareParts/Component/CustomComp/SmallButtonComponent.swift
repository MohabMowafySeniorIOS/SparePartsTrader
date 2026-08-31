//
//  SmallButtonComponent.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//
import SwiftUI

struct SmallButtonComponent: View {
    var action: () -> Void
    var title: String
    var body: some View {
        Button {
            action()
        } label: {
            Text(title.localized)
                .foregroundStyle(.white)
                .font(.custom(AppFont.bold.rawValue, size: 18))
                .padding(.horizontal)
                .padding(.vertical,8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.MainColor)
                )
               
        }
    }
}
