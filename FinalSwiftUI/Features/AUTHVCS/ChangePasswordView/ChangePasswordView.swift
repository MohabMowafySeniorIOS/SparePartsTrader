//
//  EnterPhoneNumberView.swift
//  Auctions
//
//  Created by Mohab on 02/06/2025.
//

import SwiftUI

struct ChangePasswordView: View {
    
    var otp: String
    var phone: String
    @ObservedObject private var viewModel: ChangePasswordViewModel
    init(viewModel: ChangePasswordViewModel, otp: String, phone: String) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.otp = otp
        self.phone = phone
    }
    
 
    @State var passText: String = ""
    @State var confirmPassText: String = ""
   
    @State var validationLabel: String = ""
    @State var isValidationLabel: Bool = false
    @State var isSelected: Bool = false
    @State var showTitle: Bool = false
   
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            mainContent .background(
                Color(Color.backGroundColor)
            )
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack {
            headerView
            scrollView
        }
    }
    
    private var headerView: some View {
        AuthHeaderView(Title: "") {
            viewModel.disMiss()
        }
    }
    
    private var scrollView: some View {
        ScrollView{
            VStack {
                header2View
                textFields
                confirmButton
            }
        }
    }
    
    private var header2View: some View {
        VStack {
            Image("languageLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 150,height: 120)
            
            Text("enter_new_password".localized)
                .padding(.bottom,40)
        }
    }
    
    @ViewBuilder
    private var textFields: some View {
        CustomePasswordTF(text: $passText, title_label: "", Validation_label: $validationLabel, is_validation_label: $isValidationLabel, isSelectable: isSelected, showTitle: showTitle, placeholder: "enter_new_password".localized)
            .padding(.horizontal)
        
        CustomePasswordTF(text: $confirmPassText, title_label: "", Validation_label: $validationLabel, is_validation_label: $isValidationLabel, isSelectable: isSelected, showTitle: showTitle, placeholder: "confirm_password".localized)
            .padding(.horizontal)
    }
    
    private var confirmButton: some View {
        //"confirm"
        ContentButtonView(title: "confirm".localized) {
             viewModel.ChangePassword(parameters: .init(auth: phone, code: otp, password: passText))
        }
        .padding()
        .padding(.top,50)
        .padding(.horizontal,25)
    }
    
}

