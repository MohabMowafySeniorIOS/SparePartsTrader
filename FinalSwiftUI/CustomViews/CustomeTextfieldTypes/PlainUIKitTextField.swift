//
//  PlainUIKitTextField.swift
//  FinalSwiftUI
//
//  حقل إدخال عام مبني على UITextField (UIKit)
//  بيستخدم في أي مكان مكانش ليه نوع محدد في textfieldTypes
//

import Foundation
import SwiftUI
import UIKit


struct PlainUIKitTextField: UIViewRepresentable {

    @Binding var text: String

    var placeholder: String = ""

    var keyboardType: UIKeyboardType = .default

    /// الحقول الرقمية دايمًا LTR وبتقبل أرقام بس
    var isNumeric: Bool = false

    var maxLength: Int? = nil

    var font: UIFont = .systemFont(ofSize: 17)

    var textColor: UIColor = UIColor(Color.CBlack)

    var tintColor: UIColor = UIColor(Color.MainColor)

    var placeholderColor: UIColor = .gray

    /// لو nil بيتحدد تلقائي حسب لغة التطبيق
    var alignment: NSTextAlignment? = nil

    var isSecure: Bool = false

    var isEnabled: Bool = true

    var onEditingChanged: ((Bool) -> Void)? = nil

    var onCommit: (() -> Void)? = nil


    // MARK: - Make UIView

    func makeUIView(context: Context) -> UITextField {

        let textField = UITextField()

        textField.delegate = context.coordinator

        textField.text = text

        textField.textColor = textColor
        textField.tintColor = tintColor
        textField.font = font

        textField.backgroundColor = .clear
        textField.borderStyle = .none

        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        textField.isEnabled = isEnabled

        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none

        applyPlaceholder(to: textField)
        applyDirection(to: textField)

        // ياخد المساحة الفاضية جوه الـ HStack من غير ما يتلغي
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)

        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.editingDidBegin(_:)),
            for: .editingDidBegin
        )

        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.editingDidEnd(_:)),
            for: .editingDidEnd
        )

        return textField
    }


    // MARK: - Update UIView

    func updateUIView(_ uiView: UITextField, context: Context) {

        context.coordinator.parent = self

        /*
         مانكتبش على الـ text و المستخدم بيكتب عشان الأرقام
         ماتختفيش، لكن لازم نطبّق أي تغيير جاي من بره
         (زي مسح الحقل بعد الإرسال) حتى لو الكيبورد مفتوح.
         */
        let isExternalChange = (text != context.coordinator.lastKnownText)

        if uiView.text != text && (isExternalChange || !uiView.isFirstResponder) {
            uiView.text = text
        }

        context.coordinator.lastKnownText = text

        if uiView.keyboardType != keyboardType {
            uiView.keyboardType = keyboardType
        }

        if uiView.isSecureTextEntry != isSecure {
            uiView.isSecureTextEntry = isSecure
        }

        if uiView.isEnabled != isEnabled {
            uiView.isEnabled = isEnabled
        }

        applyPlaceholder(to: uiView)
        applyDirection(to: uiView)
    }


    // MARK: - Helpers

    private func applyPlaceholder(to textField: UITextField) {

        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ]
        )
    }

    private func applyDirection(to textField: UITextField) {

        if isNumeric {

            // الأرقام دايمًا من الشمال لليمين
            textField.textAlignment = alignment ?? .left
            textField.semanticContentAttribute = .forceLeftToRight

        } else if isArabic {

            textField.textAlignment = alignment ?? .right
            textField.semanticContentAttribute = .forceRightToLeft

        } else {

            textField.textAlignment = alignment ?? .left
            textField.semanticContentAttribute = .forceLeftToRight
        }
    }


    // MARK: - Coordinator

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }


    final class Coordinator: NSObject, UITextFieldDelegate {

        var parent: PlainUIKitTextField

        /// آخر قيمة إحنا عارفينها، عشان نفرّق بين كتابة المستخدم
        /// وبين تغيير جاي من الكود
        var lastKnownText: String

        init(_ parent: PlainUIKitTextField) {
            self.parent = parent
            self.lastKnownText = parent.text
        }


        @objc
        func editingDidBegin(_ textField: UITextField) {
            parent.onEditingChanged?(true)
        }


        @objc
        func editingDidEnd(_ textField: UITextField) {
            let value = textField.text ?? ""
            lastKnownText = value
            parent.text = value
            parent.onEditingChanged?(false)
        }


        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {

            guard
                let currentText = textField.text,
                let textRange = Range(range, in: currentText)
            else {
                return false
            }

            let updatedText = currentText.replacingCharacters(
                in: textRange,
                with: string
            )

            if parent.isNumeric {

                // السماح بالمسح
                if string.isEmpty {
                    lastKnownText = updatedText
                    parent.text = updatedText
                    return true
                }

                /*
                 Character.isNumber بيشمل الأرقام العربية
                 والهندية كمان: 0 1 2 / ٠ ١ ٢ / ۰ ۱ ۲
                 */
                let containsOnlyNumbers = string.allSatisfy { $0.isNumber }

                guard containsOnlyNumbers else {
                    return false
                }
            }

            if let maxLength = parent.maxLength,
               updatedText.count > maxLength {
                return false
            }

            lastKnownText = updatedText
            parent.text = updatedText

            return true
        }


        func textFieldShouldReturn(_ textField: UITextField) -> Bool {

            textField.resignFirstResponder()
            parent.onCommit?()

            return true
        }
    }
}
