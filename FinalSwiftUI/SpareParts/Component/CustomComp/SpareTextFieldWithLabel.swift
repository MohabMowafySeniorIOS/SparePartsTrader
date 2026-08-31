//
//  SpareTextFieldWithLabel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 17/07/2025.
//

import SwiftUI

enum TextFieldType {
    case pieceName
    case PieceNum
    case pieceCount
}

struct SpareTextFieldWithLabel: View {
    
    @Binding var text: String
    @State var title_label: String = ""
    @State var Validation_label: String = ""
    @Binding var is_validation_label: Bool
    @State var is_title_label: Bool
    @State private var isEditing = false
    @State var placeholder: String = ""
    @Binding var fieldtype: TextFieldType?
    @State var keyBoardType: UIKeyboardType = .default
    var body: some View {
        VStack(spacing:4) {
            VStack(spacing:8) {
                HStack {
                    CustomLabel_text(imageName: title_label, labelText: title_label)
                    Spacer()
                }
                ZStack {
                    PlainUIKitTextField(
                        text: $text,
                        placeholder: placeholder,
                        keyboardType: keyBoardType,
                        isNumeric: keyBoardType == .numberPad || keyBoardType == .decimalPad,
                        onEditingChanged: { editing in
                            isEditing = editing
                        }
                    )
                    .padding()
                    .frame(height: 43)
                    .background(Color.CWhite)
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke((isEditing || !text.isEmpty) ? Color.MainColor : Color.TextBorderColor, lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                    .padding(1)
                }
                if !is_validation_label {
                    HStack{
                        Text(Validation_label.localized)
                            .font(addFont(fontType: .bold, size: 12))
                            .foregroundStyle(Color.CRed)
                        
                        Spacer()
                    }
                }
                
            }
        }
       
        
        .onAppear {
            switch fieldtype {
            case .pieceName:
                self.title_label = "Piece Name".localized
                self.$Validation_label.wrappedValue = "Please enter a valid piece name.".localized
                self.placeholder = "Enter Piece Name".localized
                self.keyBoardType = .default
                
            case .PieceNum:
                self.title_label = "Piece Number".localized
                self.$Validation_label.wrappedValue = "Please enter a valid piece number.".localized
                self.placeholder = "Enter Piece number".localized
                self.keyBoardType = .numberPad
                
            case .pieceCount:
                self.title_label = "Piece Count".localized
                self.$Validation_label.wrappedValue = "Please enter a valid piece Count.".localized
                self.placeholder = "Enter Piece Count".localized
                self.keyBoardType = .numberPad
                
            default:
                break
            }
        }
    }
}
    

