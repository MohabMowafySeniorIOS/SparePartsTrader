//
//  CenteredPopupModifier.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 17/07/2025.
//

import SwiftUI

struct CenteredPopupModifier<PopupContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let popupContent: () -> PopupContent

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                popupContent()
                    .transition(.scale)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

