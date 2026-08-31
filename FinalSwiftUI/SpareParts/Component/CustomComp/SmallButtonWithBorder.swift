//
//  SmallButtonWithBorder.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import SwiftUI

struct SmallButtonWithBorder: View {
    var action: () -> Void
    var title: String
    var body: some View {
        Button {
            action()
        } label: {
            Text(title.localized)
                .foregroundStyle(Color.MainColor)
                .font(addFont(fontType: .bold, size: 16))
                .frame(width: 150, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: StrokeStyle())
                        .fill(Color.MainColor)
                )
                .padding(1)
        }
    }
}
#Preview(body: {
    SmallButtonWithBorder(action: {}, title: "any")
})
