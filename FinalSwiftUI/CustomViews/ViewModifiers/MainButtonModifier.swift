//
//  MainButtonModifier.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/7/25.
//

import Foundation
import SwiftUI

struct DefaultButtonViewModifier : ViewModifier {
    let bgColor : Color
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(bgColor)
            .cornerRadius(24)
            .padding(0)
    }
}

extension View {
    func mainButtunFormating(bgColor:Color = Color.MainColor)-> some View{
        modifier(DefaultButtonViewModifier(bgColor: bgColor))
        
    }
}
