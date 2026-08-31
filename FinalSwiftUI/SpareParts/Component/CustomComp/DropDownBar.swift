//
//  DropDownBar.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 16/07/2025.
//

import SwiftUI
struct DropDownBar: View {
    @Binding var isDropDownActive: Bool
    var title: String
    var body: some View {
        HStack{
            Text(title.localized)
            Spacer()
            Image(systemName: "chevron.down")
                .rotationEffect(.degrees(isDropDownActive ? 180 : 0))
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle())
        )
        .padding()
       
    }
}
