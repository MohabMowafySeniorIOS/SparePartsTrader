//
//  CustomMobileTextField.swift
//  FinalSwiftUI
//  Created by Mohab on 15/05/2025.
//
import Foundation
import SwiftUI
import UIKit

struct CustomMobileTextField: View {

    @Binding var text: String
    @Binding var Validation_label: String
    @Binding var is_validation_label: Bool

    @State var isPhoneNumber: Bool
    @State private var isEditing = false
    @State var isSelectable: Bool
    @State var showTitle: Bool

    var placeholder: String

    var body: some View {

        VStack(spacing: 4) {

            VStack(spacing: 8) {

                // MARK: - Title

                if showTitle {

                    HStack {

                        CustomLabel_text(
                            imageName: "",
                            labelText: "phone_number".localized
                        )

                        Spacer()
                    }
                }

                // MARK: - Phone Field

                HStack(spacing: 8) {

                    // MARK: - Country Code
                    // دايمًا على الشمال في العربي والإنجليزي

                    HStack(spacing: 8) {

                        Text("+966")
                            .foregroundColor(
                                Color.TextBorderColor
                            )

                        Rectangle()
                            .fill(Color.TextBorderColor)
                            .frame(
                                width: 1,
                                height: 33
                            )
                    }
                    .fixedSize()


                    // Phone number - UIKit
                    CustomPhoneTextField(
                        text: $text,
                        placeholder: placeholder.localized,
                        isEditing: $isEditing
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                }
                .environment(\.layoutDirection, .leftToRight)
                .padding(.horizontal, 16)
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


                // MARK: - Validation

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
}


// MARK: - UIKit Phone TextField

struct CustomPhoneTextField: UIViewRepresentable {

    @Binding var text: String

    let placeholder: String

    @Binding var isEditing: Bool


    // MARK: - Create

    func makeUIView(
        context: Context
    ) -> UITextField {

        let textField = UITextField()

        textField.delegate =
            context.coordinator


        // MARK: Text

        textField.text =
            text

        textField.placeholder =
            placeholder

        textField.textColor =
            UIColor(Color.CBlack)

        textField.tintColor =
            UIColor(Color.MainColor)

        textField.font =
            UIFont.systemFont(
                ofSize: 17
            )

        textField.backgroundColor =
            .clear

        textField.borderStyle =
            .none


        // MARK: Keyboard

        textField.keyboardType =
            .phonePad


        // MARK: Phone Direction

        /*
         Phone numbers should ALWAYS be
         Left-To-Right.

         Even if the app language is Arabic.
         */

        textField.textAlignment =
            .left

        textField.semanticContentAttribute =
            .forceLeftToRight


        // MARK: Padding

        textField.leftView =
            UIView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: 4,
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
                    width: 4,
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


    // MARK: - Update

    func updateUIView(
        _ uiView: UITextField,
        context: Context
    ) {

        /*
         VERY IMPORTANT:

         Don't continuously assign:

             uiView.text = text

         while the user is typing.

         This is one of the things that can
         cause the cursor/display to behave
         incorrectly.
         */

        if !uiView.isFirstResponder &&
            uiView.text != text {

            uiView.text =
                text
        }


        // Placeholder

        if uiView.placeholder !=
            placeholder {

            uiView.placeholder =
                placeholder
        }


        // Always LTR

        uiView.textAlignment =
            .left

        uiView.semanticContentAttribute =
            .forceLeftToRight
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
            CustomPhoneTextField


        init(
            _ parent:
                CustomPhoneTextField
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
        }


        // MARK: Editing End

        @objc
        func editingDidEnd(
            _ textField: UITextField
        ) {

            parent.isEditing =
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


            // MARK: Delete

            if string.isEmpty {

                parent.text =
                    updatedText

                return true
            }


            // MARK: Normalize Arabic Numbers

            let normalized =
                updatedText.toEnglishDigits()


            // MARK: Only Numbers

            let filtered =
                normalized.filter {
                    $0.isNumber
                }


            // MARK: Maximum 10 digits

            let finalText =
                String(
                    filtered.prefix(10)
                )


            // Update Binding

            parent.text =
                finalText


            /*
             We return false because we already
             updated the text through UIKit below.

             This prevents UIKit from inserting
             the original Arabic characters again.
             */

            textField.text =
                finalText


            return false
        }


        // MARK: Return

        func textFieldShouldReturn(
            _ textField: UITextField
        ) -> Bool {

            textField.resignFirstResponder()

            return true
        }
    }
}
extension String {

    func toEnglishDigits() -> String {

        let arabicNumbers = [
            "٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4",
            "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9"
        ]

        let persianNumbers = [
            "۰": "0", "۱": "1", "۲": "2", "۳": "3", "۴": "4",
            "۵": "5", "۶": "6", "۷": "7", "۸": "8", "۹": "9"
        ]

        var result = self

        arabicNumbers.forEach {
            result = result.replacingOccurrences(of: $0.key, with: $0.value)
        }

        persianNumbers.forEach {
            result = result.replacingOccurrences(of: $0.key, with: $0.value)
        }

        return result
    }
}
