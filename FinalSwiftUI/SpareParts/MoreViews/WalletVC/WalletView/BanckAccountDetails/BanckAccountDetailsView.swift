//
//  WithDrawView.swift
//  SpareParts
//
//  Created by Mohab on 12/02/2026.
//

import SwiftUI

struct BanckAccountDetailsView: View {
    @StateObject var balanceField            = CustomTFieldState(validationLabel: "validation_required".localized)
    @StateObject var bankNameField            = CustomTFieldState(validationLabel: "validation_required".localized)
    @StateObject var benefitField            = CustomTFieldState(validationLabel: "validation_required".localized)
    @StateObject var accountNumberField            = CustomTFieldState(validationLabel: "validation_required".localized)
    @StateObject var IBANField            = CustomTFieldState(validationLabel: "validation_required".localized)
    
   @ObservedObject var viewModel: BanckAccountDetailsViewModel
    var item :TransactionItem?
    init(viewModel: BanckAccountDetailsViewModel,item: TransactionItem?) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        print(item)
        self.item = item
       
    }
    
    var body: some View {
        mainContent
            .background(
                Color(Color.backGroundColor)
            )
            .onAppear {
                balanceField.input = item?.amount ?? ""
                bankNameField.input = item?.bank_name ?? ""
                benefitField.input = item?.account_name ?? ""
                accountNumberField.input = item?.account_number ?? ""
                IBANField.input = item?.iban ?? ""
            }
    }
    
    private var mainContent: some View {
        
        VStack {
            headerView
            ShowViewState(state: viewModel.state) { Model in
                textFields
            }
            Spacer()
           // sectionButtons
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
                    text: $bankNameField.input,
                    Validation_label: $bankNameField.validationLabel,
                    is_validation_label: $bankNameField.isValidationHidden,
                    is_title_label: true,
                    textType: .BankName
                ).disabled(true)
                
                CustomTextField(
                    text: $benefitField.input,
                    Validation_label: $benefitField.validationLabel,
                    is_validation_label: $benefitField.isValidationHidden,
                    is_title_label: true,
                    textType: .benefiterName
                ).disabled(true)
                
                CustomTextField(
                    text: $accountNumberField.input,
                    Validation_label: $accountNumberField.validationLabel,
                    is_validation_label: $accountNumberField.isValidationHidden,
                    is_title_label: true,
                    textType: .BankAccount
                ).disabled(true)
                
                CustomTextField(
                    text: $IBANField.input,
                    Validation_label: $IBANField.validationLabel,
                    is_validation_label: $IBANField.isValidationHidden,
                    is_title_label: true,
                    textType: .IBAN
                ).disabled(true)
                
            }.padding(16)
        }
    }
    
    @ViewBuilder
    private var sectionButtons: some View {
        VStack(spacing: 16) {
            ContentButtonView(title: "Request Confirmation".localized) {
                if isValid(){
                    viewModel.withDraw(parameters: .init(amount:balanceField.input, bank_name: bankNameField.input, account_name: bankNameField.input, account_number: accountNumberField.input, iban: IBANField.input))
                }
               
            }
            
            CustomeButtonWithBorderColor(title: "cancel".localized) {
                viewModel.disMiss()
            }
        }.padding()
        
    }
    
    func isValid() -> Bool {
        var x: Bool = true
        
        validateField(balanceField,  x: &x)
        validateField(bankNameField, x: &x)
        validateField(benefitField, x: &x)
        validateField(accountNumberField,  x: &x)
        validateField(IBANField, x: &x)
        
        return x
    }
}

