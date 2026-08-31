//
//  ConfirmActionPopup.swift
//  SparePartsTrader
//
//  Created by Mohab Mowafy on 07/08/2026.
//



//
//  ConfirmActionPopup.swift
//  SpareParts
//
//  Reusable confirmation popup (e.g. Logout / Delete Account) with a title,
//  a message and two buttons.
//


//
//  ConfirmActionPopup.swift
//  SpareParts
//
//  Reusable confirmation popup (e.g. Logout / Delete Account) with a title,
//  a message and two buttons.
//

import Foundation
import SwiftUI

struct ConfirmActionPopup: View {

    var title: String
    var message: String
    var confirmTitle: String = "confirm".localized
    var cancelTitle: String = "cancel".localized
    var confirmColor: Color = Color.CRed
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundColor(confirmColor)

            Text(title)
                .font(addFont(fontType: .bold, size: 17))
                .foregroundColor(Color.CBlack)
                .multilineTextAlignment(.center)

            Text(message)
                .font(addFont(fontType: .Regular, size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {

                Button(action: onCancel) {
                    Text(cancelTitle)
                        .font(addFont(fontType: .bold, size: 15))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .foregroundColor(Color.CBlack)
                        .cornerRadius(20)
                }

                Button(action: onConfirm) {
                    Text(confirmTitle)
                        .font(addFont(fontType: .bold, size: 15))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(confirmColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
        .padding(.horizontal, 32)
        .environment(\.layoutDirection, appLanguage == "en" ? .leftToRight : .rightToLeft)
    }
}

// MARK: - Overlay modifier so it can be shown on top of any view

struct ConfirmActionOverlay: ViewModifier {
    @Binding var isPresented: Bool
    var title: String
    var message: String
    var confirmTitle: String = "confirm".localized
    var cancelTitle: String = "cancel".localized
    var confirmColor: Color = Color.CRed
    var onConfirm: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
                    .transition(.opacity)

                ConfirmActionPopup(
                    title: title,
                    message: message,
                    confirmTitle: confirmTitle,
                    cancelTitle: cancelTitle,
                    confirmColor: confirmColor,
                    onConfirm: {
                        isPresented = false
                        onConfirm()
                    },
                    onCancel: {
                        isPresented = false
                    }
                )
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}

extension View {
    func confirmActionAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "confirm".localized,
        cancelTitle: String = "cancel".localized,
        confirmColor: Color = Color.CRed,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(
            ConfirmActionOverlay(
                isPresented: isPresented,
                title: title,
                message: message,
                confirmTitle: confirmTitle,
                cancelTitle: cancelTitle,
                confirmColor: confirmColor,
                onConfirm: onConfirm
            )
        )
    }
}

#Preview {
    ConfirmActionPopup(
        title: "logout_confirm_title".localized,
        message: "logout_confirm_message".localized,
        onConfirm: { print("confirmed") },
        onCancel: { print("cancelled") }
    )
}
