//
//  SidMEnueView.swift
//  MyAuctions
//
//  Created by Mohab on 15/06/2025.
//


//
//  SidMEnueView.swift
//  FinalSwiftUI
//
//  Created by Mohab on 17/05/2025.
//

import SwiftUI

struct SidMEnueView: View {
    var title : String
    let textColor: Color
    var image: String?
    var body: some View {
        HStack(spacing: 16) {
            Image(image ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24,height: 32)

            Text(title)
                 .frame(maxWidth: .infinity, alignment: .leading)
                 .font(addFont(fontType: .Regular, size: 16))
                 .foregroundColor(textColor)

            Image(systemName: "chevron.forward")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.CGray2)
        }
        .padding(.vertical, 14)

    }
}

#Preview {
    SidMEnueView(title: "Home", textColor: Color.MainColor, image: "Path 38243 (1)")
}
