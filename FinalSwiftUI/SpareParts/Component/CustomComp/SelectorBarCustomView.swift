//
//  SelectorBarCustomView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 16/07/2025.
//

import SwiftUI

struct SelectorBarCustomView: View {
    var title: String
    var isSelected: Bool

    var body: some View {
        HStack() {
            Circle()
                .fill(isSelected ? Color.MainColor : .clear)
                .frame(width: 15,height: 15)
                .overlay {
                    ZStack{
                        Image(systemName: "checkmark")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.CWhite)
                        Circle()
                            .stroke(style: StrokeStyle())
                            .fill(isSelected ? Color.MainColor : Color.CGray1)

                    }
                }
            
            Text(title.localized)
            Spacer()
        }
    }
}
//#Preview {
//    SelectorBarCustomView(title: "test", isSelected: .constant(true))
//}
