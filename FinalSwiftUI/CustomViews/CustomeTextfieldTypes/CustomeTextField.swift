//
//  CustomeTextField.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 27/11/2024.
//

import Foundation
import SwiftUI
import UIKit


// MARK: - TextField Types

enum textfieldTypes {
    
    case userNAme
    case Email
    case City
    case Id
    case Phone
    case Password
    case ConfirmPassword
    case messageType
    case balance
    case BankName
    case benefiterName
    case BankAccount
    case IBAN
    
    // Merchant data
    case arabicTraderName
    case englishTraderName
    case commercialNumber
}


// MARK: - Custom TextField

struct CustomTextField: View {
    
    @Binding var text: String
    @Binding var Validation_label: String
    @Binding var is_validation_label: Bool
    
    @State var is_title_label: Bool
    @State var textType: textfieldTypes
    
    @State private var title_label: String = ""
    @State private var placeholder: String = ""
    
    @State private var keyBoardType: UIKeyboardType = .default
    
    @State private var isEditing = false
    
    @State private var isConfigured = false
    
    
    // MARK: - Body
    
    var body: some View {
        
        VStack(spacing: 4) {
            
            VStack(spacing: 8) {
                
                // MARK: Title
                
                if is_title_label {
                    
                    HStack {
                        
                        CustomLabel_text(
                            imageName: title_label,
                            labelText: title_label
                        )
                        
                        Spacer()
                    }
                }
                
                
                // MARK: TextField
                
                ZStack {
                    
                    CustomUIKitTextField(
                        text: $text,
                        placeholder: placeholder,
                        keyboardType: keyBoardType,
                        textType: textType,
                        isArabic: isArabic,
                        isEditing: $isEditing
                    )
                    .frame(height: 48)
                }
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
                
                
                // MARK: Validation
                
                if !is_validation_label {
                    
                    HStack {
                        
                        Text(
                            Validation_label.localized
                        )
                        .font(
                            addFont(
                                fontType: .bold,
                                size: 12
                            )
                        )
                        .foregroundStyle(
                            Color.CRed
                        )
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            configureField()
        }
        .onChange(
            of: languageManager.currentLanguage
        ) { _ in
            
            configureField()
        }
    }
    
    
    // MARK: - Configure Field
    
    private func configureField() {
        
        // Reset keyboard first.
        // This is important when the field
        // configuration changes.
        
        keyBoardType = .default
        
        
        switch textType {
            
        case .userNAme:
            
            title_label =
                "full_name".localized
            
            placeholder =
                "enter_name".localized
            
            
        case .Email:
            
            title_label =
                "email".localized
            
            placeholder =
                "name@gmail.com"
            
            keyBoardType =
                .emailAddress
            
            
        case .City:
            
            title_label =
                "city".localized
            
            placeholder =
                "gaddah".localized
            
            
        case .Id:
            
            title_label =
                "id_number".localized
            
            placeholder =
                "23489756"
            
            keyBoardType =
                .numberPad
            
            
        case .BankAccount:
            
            title_label =
                "bank_account_number".localized
            
            placeholder =
                "2389476342"
            
            keyBoardType =
                .numberPad
            
            
        case .Phone:
            
            title_label =
                "phone_number".localized
            
            placeholder =
                "538804683"
            
            keyBoardType =
                .phonePad
            
            
        case .Password:
            
            title_label =
                "password".localized
            
            placeholder =
                "**********"
            
            keyBoardType =
                .default
            
            
        case .ConfirmPassword:
            
            title_label =
                "confirm_password".localized
            
            placeholder =
                "**********"
            
            keyBoardType =
                .default
            
            
        case .messageType:
            
            title_label =
                "Message_Title".localized
            
            placeholder =
                ""
            
            keyBoardType =
                .default
            
            
        case .balance:
            
            title_label =
                "The amount of money to be withdrawn".localized
            
            placeholder =
                "The amount of money to be withdrawn".localized
            
            keyBoardType =
                .decimalPad
            
            
        case .BankName:
            
            title_label =
                "Bank Name".localized
            
            placeholder =
                "Bank Name".localized
            
            keyBoardType =
                .default
            
            
        case .benefiterName:
            
            title_label =
                "Beneficiary's name".localized
            
            placeholder =
                "Beneficiary's name".localized
            
            keyBoardType =
                .default
            
            
        case .IBAN:
            
            title_label =
                "IBAN number".localized
            
            placeholder =
                "IBAN number".localized
            
            keyBoardType =
                .default
            
            
        case .arabicTraderName:
            
            title_label =
                "Trade name (in Arabic)".localized
            
            placeholder =
                "Trade name (in Arabic)".localized
            
            keyBoardType =
                .default
            
            
        case .englishTraderName:
            
            title_label =
                "Trade name (in English)".localized
            
            placeholder =
                "Trade name (in English)".localized
            
            keyBoardType =
                .default
            
            
        case .commercialNumber:
            
            title_label =
                "Enter the commercial registration number".localized
            
            placeholder =
                "Enter the commercial registration number".localized
            
            keyBoardType =
                .numberPad
        }
    }
}


// MARK: - UIKit TextField

struct CustomUIKitTextField: UIViewRepresentable {
    
    @Binding var text: String
    
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    let textType: textfieldTypes
    let isArabic: Bool
    
    @Binding var isEditing: Bool
    
    
    // MARK: - Make UIView
    
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
            keyboardType
        
        
        // MARK: Direction
        
        if isNumericField {
            
            // Numbers ALWAYS LTR
            
            textField.textAlignment =
                .left
            
            textField.semanticContentAttribute =
                .forceLeftToRight
            
        } else {
            
            if isArabic {
                
                textField.textAlignment =
                    .right
                
                textField.semanticContentAttribute =
                    .forceRightToLeft
                
            } else {
                
                textField.textAlignment =
                    .left
                
                textField.semanticContentAttribute =
                    .forceLeftToRight
            }
        }
        
        
        // MARK: Padding
        
        textField.leftView =
            UIView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: 16,
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
                    width: 16,
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
        
        /*
         VERY IMPORTANT:
         
         Don't overwrite UITextField.text
         while the user is typing.
         
         This prevents the disappearing
         numbers problem.
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
        
        
        // Keyboard
        
        if uiView.keyboardType !=
            keyboardType {
            
            uiView.keyboardType =
                keyboardType
        }
        
        
        // Direction
        
        if isNumericField {
            
            uiView.textAlignment =
                .left
            
            uiView.semanticContentAttribute =
                .forceLeftToRight
            
        } else {
            
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
        }
    }
    
    
    // MARK: - Numeric Field
    
    private var isNumericField: Bool {
        
        switch textType {
            
        case .Id,
             .Phone,
             .BankAccount,
             .balance,
             .commercialNumber:
            
            return true
            
        default:
            
            return false
        }
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
            CustomUIKitTextField
        
        
        init(
            _ parent:
                CustomUIKitTextField
        ) {
            
            self.parent =
                parent
        }
        
        
        // MARK: - Editing Begin
        
        @objc
        func editingDidBegin(
            _ textField: UITextField
        ) {
            
            parent.isEditing =
                true
        }
        
        
        // MARK: - Editing End
        
        @objc
        func editingDidEnd(
            _ textField: UITextField
        ) {
            
            parent.isEditing =
                false
        }
        
        
        // MARK: - Character Changes
        
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
            
            
            // MARK: Numeric Fields
            
            if parent.isNumericField {
                
                // Allow delete
                
                if string.isEmpty {
                    
                    parent.text =
                        updatedText
                    
                    return true
                }
                
                
                /*
                 Character.isNumber supports:
                 
                 0 1 2 3
                 ٠ ١ ٢ ٣
                 ۰ ۱ ۲ ۳
                 
                 So Arabic/Persian numbers
                 are NOT removed.
                 */
                
                let containsOnlyNumbers =
                    string.allSatisfy {
                        $0.isNumber
                    }
                
                
                guard containsOnlyNumbers else {
                    
                    return false
                }
                
                
                // Maximum length
                
                let maxLength: Int
                
                switch parent.textType {
                    
                case .Phone:
                    
                    maxLength = 10
                    
                case .Id,
                     .BankAccount,
                     .commercialNumber:
                    
                    maxLength = 30
                    
                case .balance:
                    
                    maxLength = 30
                    
                default:
                    
                    maxLength = 30
                }
                
                
                let digitCount =
                    updatedText.filter {
                        $0.isNumber
                    }.count
                
                
                guard digitCount <= maxLength else {
                    
                    return false
                }
                
                
                parent.text =
                    updatedText
                
                return true
            }
            
            
            // MARK: Normal Fields
            
            parent.text =
                updatedText
            
            return true
        }
        
        
        // MARK: - Return
        
        func textFieldShouldReturn(
            _ textField: UITextField
        ) -> Bool {
            
            textField.resignFirstResponder()
            
            return true
        }
    }
}
