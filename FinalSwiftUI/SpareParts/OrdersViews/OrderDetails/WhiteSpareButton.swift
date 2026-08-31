//
//  SimpleSpareButton.swift
//  SpareParts
//
//  Created by مهاب موافي on 2/10/26.
//

import SwiftUI


struct WhiteSpareButton: View {
    
    var buttonTitle: String
    var action: () -> Void
    var widthValue: CGFloat
    var heightValue: CGFloat

    var body: some View {
        Button {
            action()
        } label: {
            Text(buttonTitle.localized)
                .foregroundStyle(Color.MainColor)
                .frame(width: widthValue, height: heightValue)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.MainColor, lineWidth: 1)
                                                    .background(Color.clear
                                                        .clipShape(RoundedRectangle(cornerRadius: 20)))
                )
        }

    }
}
