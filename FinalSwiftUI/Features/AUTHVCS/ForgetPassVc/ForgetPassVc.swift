//
//  ForgetPassVc.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/6/25.
//

import SwiftUI
import Combine

struct ForgetPassVc: View {
  
    @State private var phoneInput = ""
    @State private var phoneValidationLabel = "Phone Number Is Required".localized
    @State private var isLabelHiddenPhone = true
    @State private var isRequiredPhone = true
    
    @State private var isForgetPassw = true
    @State private var isNumberAlert: Bool = false
    // MARK: - View
    
    @ObservedObject private var viewModel: ForgetPasswordViewModel
    init(viewModel: ForgetPasswordViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            mainContent .background(
                Color(Color.backGroundColor)
            )
        }.onReceive(viewModel.$Model) { Model in
            guard let userData = Model else { return }
            viewModel.showVerify(isForget: true, phone: phoneInput)
        }
       
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack{
            AuthHeaderView(Title: "password_reset".localized) {
                viewModel.pop()
            }
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 40) {
                        logoSection
                        formSection
                    }
                }
                .padding(16)
            }
            .mask(RoundedRectangle(cornerRadius: 0))
        }
    }
    
    // MARK: - Logo Section
    
    private var logoSection: some View {
        VStack(spacing: 40) {
            Image.Splashlogo
                .resizable()
                .logoSize()
            
            Text("enter_phone_number".localized)
                .font(.custom(AppFont.SemiBold.rawValue, size: 19))
                .foregroundColor(Color.TitleColor)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Form Section
    
    private var formSection: some View {
        VStack(spacing: 140) {
            VStack(spacing: 24) {
                CustomMobileTextField(
                    text: $phoneInput,
                    Validation_label: $phoneValidationLabel,
                    is_validation_label: $isLabelHiddenPhone,
                    isPhoneNumber: true,
                    isSelectable: false,
                    showTitle: false,
                    placeholder: "phone_placeholder".localized
                )
                if isNumberAlert{
                    HStack{
                        Spacer()
                        Text("phone_number_incorrect".localized)
                            .foregroundStyle(Color.CRed)
                            .font(addFont(fontType: .bold, size: 12))
                        
                    }
                }
            }
            
            buttonSection
                .padding(.horizontal)
                .padding(.horizontal)
        }
    }
    
    // MARK: - Button Section
    
    private var buttonSection: some View {
        VStack(spacing: 12) {
            ContentButtonView(title: "confirm_button".localized) {
                if isNumberValid(text: phoneInput).0 {
                    viewModel.forgotPass(urlEndPoint: .forgot_password, methodType: .post, parameters: .init(phone: phoneInput))
                }else{
                    isNumberAlert = true
                }
            }
           
        }
    }
}


