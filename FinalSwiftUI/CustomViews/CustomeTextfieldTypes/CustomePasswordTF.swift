//
//  CustomePasswordTF.swift
//  FinalSwiftUI
//
//  Created by Mohab on 15/05/2025.
//

import SwiftUI
import UIKit

// MARK: - Language

var isArabic: Bool {
    languageManager.currentLanguage == "ar"
}


// MARK: - Custom Password TextField

struct CustomePasswordTF: View {

    @Binding var text: String

    var title_label: String

    @Binding var Validation_label: String
    @Binding var is_validation_label: Bool

    @State private var isEditing = false

    @State var isSelectable: Bool
    @State var showTitle: Bool

    @State private var isSecure = true

    @FocusState private var isFocused: Bool

    var placeholder: String


    // MARK: - Body

    var body: some View {

        VStack(spacing: 4) {

            VStack(spacing: 8) {

                // MARK: Title

                if showTitle {

                    HStack {

                        CustomLabel_text(
                            imageName: title_label,
                            labelText: title_label
                        )

                        Spacer()
                    }
                }


                // MARK: Password Container

                HStack(spacing: 12) {

                    // MARK: UIKit TextField

                    PasswordUIKitTextField(
                        text: $text,
                        placeholder: placeholder,
                        isSecure: isSecure,
                        isArabic: isArabic,
                        isEditing: $isEditing,
                        isFocused: $isFocused
                    )
                    .frame(
                        height: 48
                    )


                    // MARK: Select Button

                    if isSelectable {

                        SelectedContentButtonView(
                            title: ""
                        ) {

                        }
                    }


                    // MARK: Eye Button

                    Button {

                        isSecure.toggle()

                        // Keep keyboard/focus

                        DispatchQueue.main.async {

                            isFocused = true
                        }

                    } label: {

                        Image(
                            systemName:
                                isSecure
                                ? "eye.slash.fill"
                                : "eye"
                        )
                        .renderingMode(.template)
                        .foregroundStyle(
                            Color.MainColor
                        )
                        .frame(
                            width: 24,
                            height: 24
                        )
                    }
                    .buttonStyle(.plain)
                }

                .padding(.horizontal, 12)

                .frame(height: 48)

                .background(
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                    .fill(Color.CWhite)
                )

                .overlay(
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                    .stroke(
                        (
                            isEditing ||
                            !text.isEmpty
                        )
                        ? Color.MainColor
                        : Color.TextBorderColor,
                        lineWidth: 1
                    )
                )

                .shadow(
                    color:
                        Color.black.opacity(0.06),
                    radius: 6,
                    x: 0,
                    y: 2
                )
            }


            // MARK: Validation

            if !is_validation_label {

                CustomValidationLabel(
                    imageName: "star.fill",
                    labelText:
                        Validation_label.localized
                )
            }
        }
    }
}


// MARK: - UIKit Password TextField
struct PasswordUIKitTextField: UIViewRepresentable {

    @Binding var text: String

    let placeholder: String
    let isSecure: Bool
    let isArabic: Bool

    @Binding var isEditing: Bool
    @FocusState.Binding var isFocused: Bool


    // MARK: - Make UIView

    func makeUIView(
        context: Context
    ) -> UITextField {

        let textField = UITextField()

        textField.delegate =
            context.coordinator

        textField.text =
            text

        textField.placeholder =
            placeholder

        textField.textColor =
            UIColor(Color.CBlack)

        textField.tintColor =
            UIColor(Color.MainColor)

        textField.backgroundColor =
            .clear

        textField.borderStyle =
            .none

        textField.font =
            UIFont.systemFont(ofSize: 17)

        textField.keyboardType =
            .default

        // MARK: Direction

        if isArabic {

            textField.textAlignment = .right
            textField.semanticContentAttribute =
                .forceRightToLeft

        } else {

            textField.textAlignment = .left
            textField.semanticContentAttribute =
                .forceLeftToRight
        }

        // MARK: Secure

        textField.isSecureTextEntry =
            isSecure

        // MARK: Padding

        textField.leftView =
            UIView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: 2,
                    height: 1
                )
            )

        textField.leftViewMode =
            .always

        textField.rightView =
            UIView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: 2,
                    height: 1
                )
            )

        textField.rightViewMode =
            .always


        // MARK: Editing Events

        textField.addTarget(
            context.coordinator,
            action: #selector(
                Coordinator.editingDidBegin(_:)
            ),
            for: .editingDidBegin
        )

        textField.addTarget(
            context.coordinator,
            action: #selector(
                Coordinator.editingDidEnd(_:)
            ),
            for: .editingDidEnd
        )


        return textField
    }


    // MARK: - Update UIView

    func updateUIView(
        _ uiView: UITextField,
        context: Context
    ) {

        // IMPORTANT:
        // Don't update text while user is typing.

        if !uiView.isFirstResponder &&
            uiView.text != text {

            uiView.text = text
        }


        // Placeholder

        if uiView.placeholder != placeholder {

            uiView.placeholder =
                placeholder
        }


        // MARK: Direction

        if isArabic {

            uiView.textAlignment =
                .right

            uiView.semanticContentAttribute =
                .forceRightToLeft

        } else {

            uiView.textAlignment =
                .left

            uiView.semanticContentAttribute =
                .forceLeftToRight
        }


        // MARK: Secure State

        if uiView.isSecureTextEntry != isSecure {

            let wasFirstResponder =
                uiView.isFirstResponder

            let selectedRange =
                uiView.selectedTextRange

            /*
             Change secure state WITHOUT
             resigning the text field.
             */

            uiView.isSecureTextEntry =
                isSecure


            // Restore cursor

            if wasFirstResponder {

                uiView.becomeFirstResponder()

                if let selectedRange {

                    uiView.selectedTextRange =
                        selectedRange
                }
            }
        }


        /*
         IMPORTANT:

         Don't do this here:

         if isFocused {
             uiView.becomeFirstResponder()
         } else {
             uiView.resignFirstResponder()
         }

         This was causing the keyboard
         to disappear.
         */
    }


    // MARK: - Coordinator

    func makeCoordinator()
        -> Coordinator {

        Coordinator(self)
    }


    final class Coordinator:
        NSObject,
        UITextFieldDelegate {


        var parent:
            PasswordUIKitTextField


        init(
            _ parent:
                PasswordUIKitTextField
        ) {

            self.parent =
                parent
        }


        // MARK: Editing Begin

        @objc
        func editingDidBegin(
            _ textField: UITextField
        ) {

            parent.isEditing =
                true

            parent.isFocused =
                true
        }


        // MARK: Editing End

        @objc
        func editingDidEnd(
            _ textField: UITextField
        ) {

            parent.isEditing =
                false

            parent.isFocused =
                false
        }


        // MARK: Text Changes

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {

            guard
                let currentText =
                    textField.text,

                let textRange =
                    Range(
                        range,
                        in: currentText
                    )
            else {

                return false
            }


            let updatedText =
                currentText.replacingCharacters(
                    in: textRange,
                    with: string
                )


            parent.text =
                updatedText


            return true
        }
    }
}


// MARK: - Password Validation

func isPasswordValid(
    password: String
) -> (Bool, String) {

    if password.isEmpty {

        return (
            false,
            "invalid password"
        )
    }

    return (
        true,
        ""
    )
}
