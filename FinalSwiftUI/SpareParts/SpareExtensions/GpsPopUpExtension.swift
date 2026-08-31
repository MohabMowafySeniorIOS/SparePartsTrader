//
//  GpsPopUpExtension.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 17/07/2025.
//
import Foundation
import SwiftUI

extension View {
    func centeredPopup<PopupContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> PopupContent) -> some View {
        self
                .modifier(CenteredPopupModifier(isPresented: isPresented, popupContent: content))
    }
}
