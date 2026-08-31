//
//  WithDrawView.swift
//  SpareParts
//
//  Created by Mohab on 12/02/2026.
//

import SwiftUI

struct WithDrawView: View {
    @StateObject var balanceField            = CustomTFieldState(validationLabel: "validation_required".localized)
//    @StateObject var bankNameField            = CustomTFieldState(validationLabel: "validation_required".localized)
//    @StateObject var benefitField            = CustomTFieldState(validationLabel: "validation_required".localized)
//    @StateObject var accountNumberField            = CustomTFieldState(validationLabel: "validation_required".localized)
//    @StateObject var IBANField            = CustomTFieldState(validationLabel: "validation_required".localized)
    
   @ObservedObject var viewModel: WithDrawViewModel
    init(viewModel: WithDrawViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        mainContent
            .background(
                Color(Color.backGroundColor)
            )
    }
    
    private var mainContent: some View {
        
        VStack {
            headerView
            ShowViewState(state: viewModel.state) { Model in
                textFields
            }
            Spacer()
            sectionButtons
        }
        
    }
    
    private var headerView: some View {
        AppHeaderView(Title: "Withdrawal of balance".localized) {
            viewModel.disMiss()
        }
    }
    
    
    private var textFields: some View {
        ScrollView{
            VStack(spacing:16) {
                
                CustomTextField(
                    text: $balanceField.input,
                    Validation_label: $balanceField.validationLabel,
                    is_validation_label: $balanceField.isValidationHidden,
                    is_title_label: true,
                    textType: .balance,
                )
                
//                CustomTextField(
//                    text: $bankNameField.input,
//                    Validation_label: $bankNameField.validationLabel,
//                    is_validation_label: $bankNameField.isValidationHidden,
//                    is_title_label: true,
//                    textType: .BankName
//                )
//                
//                CustomTextField(
//                    text: $benefitField.input,
//                    Validation_label: $benefitField.validationLabel,
//                    is_validation_label: $benefitField.isValidationHidden,
//                    is_title_label: true,
//                    textType: .benefiterName
//                )
//                
//                CustomTextField(
//                    text: $accountNumberField.input,
//                    Validation_label: $accountNumberField.validationLabel,
//                    is_validation_label: $accountNumberField.isValidationHidden,
//                    is_title_label: true,
//                    textType: .BankAccount
//                )
//                
//                CustomTextField(
//                    text: $IBANField.input,
//                    Validation_label: $IBANField.validationLabel,
//                    is_validation_label: $IBANField.isValidationHidden,
//                    is_title_label: true,
//                    textType: .IBAN
//                )
                
            }.padding(16)
        }
    }
    
    @ViewBuilder
    private var sectionButtons: some View {
        VStack(spacing: 16) {
            ContentButtonView(title: "Request Confirmation".localized) {
                if isValid(){
                    viewModel.withDraw(parameters: .init(amount:balanceField.input))
                }
            //    , bank_name: bankNameField.input, account_name: bankNameField.input, account_number: accountNumberField.input, iban: IBANField.input
            }
            
            CustomeButtonWithBorderColor(title: "cancel".localized) {
                viewModel.disMiss()
            }
        }.padding()
        
    }
    
    func isValid() -> Bool {
        var x: Bool = true
        
        validateField(balanceField,  x: &x)
//        validateField(bankNameField, x: &x)
//        validateField(benefitField, x: &x)
//        validateField(accountNumberField,  x: &x)
//        validateField(IBANField, x: &x)
        
        return x
    }
}

