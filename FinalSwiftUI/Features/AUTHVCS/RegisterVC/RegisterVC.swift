//
//  RegisterVC.swift
//  FinalSwiftUI
//
//  Created by Mohab on 17/05/2025.
//

import SwiftUI



class CustomTFieldState: ObservableObject {
    @Published var input: String = ""
    @Published var validationLabel: String = ""
    @Published var isValidationHidden: Bool = true
    
    init(validationLabel: String) {
        self.validationLabel = validationLabel
    }
    
}

class PasswordTFieldState: ObservableObject {
    @Published var input: String = ""
    @Published var validationLabel: String = ""
    @Published var isValidationHidden: Bool = true
     var titleLabel: String = ""
    
    init(validationLabel: String,titleLabel: String) {
        self.validationLabel = validationLabel
        self.titleLabel = titleLabel
    }
    
}

struct RegisterVC: View {
    
    @StateObject var nameField            = CustomTFieldState(validationLabel: "name_required")
    @StateObject var phoneField           = CustomTFieldState(validationLabel: "phone_number_required")
    @StateObject var emailField           = CustomTFieldState(validationLabel: "email_required")
   
    @StateObject var passwordField        = PasswordTFieldState(validationLabel: "password_required", titleLabel: "password".localized)
    @StateObject var confirmpasswordField = PasswordTFieldState(validationLabel: "confirm_password_required", titleLabel: "confirm_password".localized)
    
   
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    
    @State private var termsIsSelected = false
    
    @State private var naviToOtp: Bool = false
    @State private var checkboxalert: Bool = false
    @State private var textColorChange: Bool = false
    
    @State var is_country_validation_label: Bool = true
    @State var Validation_country_label: String = "Country Is Required".localized
    
    @State var is_city_validation_label: Bool = true
    @State var Validation_city_label: String = "City Is Required".localized
    
   
    
    @ObservedObject private var viewModel: RegisterViewModel
    init(viewModel: RegisterViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            mainContent .background(
                Color(Color.backGroundColor)
            )
        }
    }
    
    private var mainContent: some View {
        VStack{
            AuthHeaderView(Title: "") {
                viewModel.disMiss()
            }
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(spacing: 51) {
                        headerView
                         textFields
                        }
                    }.padding(16)
                }.mask(RoundedRectangle(cornerRadius: 0))
            }
            registerButton
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 35) {
            Image.Splashlogo
                .resizable()
                .logoSize()
            
            Text("register_title".localized)
                .font(.custom(AppFont.SemiBold.rawValue, size: 18))
                .foregroundColor(Color.TitleColor)
                .multilineTextAlignment(.center)

        }
    }
    
    
    private var textFields: some View {
        VStack(spacing:16) {
            
            CustomTextField(
                text: $nameField.input,
                Validation_label: $nameField.validationLabel,
                is_validation_label: $nameField.isValidationHidden,
                is_title_label: true,
                textType: .userNAme
            )
            
            CustomMobileTextField(
                text: $phoneField.input,
                Validation_label: $phoneField.validationLabel,
                is_validation_label: $phoneField.isValidationHidden,
                isPhoneNumber: true,
                isSelectable: false,
                showTitle: true,
                placeholder: "583694601".localized
            )
            
            CustomTextField(
                text: $emailField.input,
                Validation_label: $emailField.validationLabel,
                is_validation_label: $emailField.isValidationHidden,
                is_title_label: true,
                textType: .Email
            )
            
            GenericDropdown(
                title: "country".localized,
                is_validation_label: $is_country_validation_label, Validation_label: $Validation_country_label,
                selectedItem: $viewModel.selectedCcountry,
                items: viewModel.countryArray,
                displayText: { $0.name ?? ""
                }
            )
            
            GenericDropdown(
                title: "city".localized,
                is_validation_label: $is_city_validation_label, Validation_label: $Validation_city_label,
                selectedItem: $viewModel.selectedCity,
                items: viewModel.cityArray,
                displayText: { $0.name ?? "" }
            )
            
            CustomePasswordTF(
                text: $passwordField.input,
                title_label: passwordField.titleLabel,
                Validation_label: $passwordField.validationLabel,
                is_validation_label: $passwordField.isValidationHidden,
                isSelectable: false,
                showTitle: true,
                placeholder: "*********".localized
            )
            
            CustomePasswordTF(
                text: $confirmpasswordField.input,
                title_label: confirmpasswordField.titleLabel,
                Validation_label: $confirmpasswordField.validationLabel,
                is_validation_label: $confirmpasswordField.isValidationHidden,
                isSelectable: false,
                showTitle: true,
                placeholder: "*********".localized
            )
        
            termsView
        }
    }
    
    private var termsView: some View {
        TermsView(isSelected: $termsIsSelected, textColorChange: $textColorChange)
            .onTapGesture {
                termsIsSelected = !termsIsSelected
            }
    }
    
    private var registerButton: some View {
        VStack {
            ContentButtonView(title: "register_submit_button".localized) {
                if isValid() {
                    viewModel.fetchUsers(urlEndPoint: .register, methodType: .post ,parameters: .init(full_name: nameField.input,email: emailField.input,phone: phoneField.input,city_id:"\(viewModel.selectedCity?.id ?? 0)", password: passwordField.input))
                }
            }
            .padding(.top)
            .padding(.horizontal,25)
        }
    }
    
    func isValid() -> Bool {
        var x: Bool = true
        
        validateField(nameField,  x: &x)
        validatePhone(phoneField, x: &x)
        validateEmail(emailField, x: &x)
        if !Check(fieldText: viewModel.selectedCcountry?.name ?? ""){
            is_country_validation_label = false
          
        }else{
            is_country_validation_label = true
        }
        if !Check(fieldText: viewModel.selectedCity?.name ?? ""){
            is_city_validation_label = false
          
        }else{
            is_city_validation_label = true
        }
        if !Check(fieldText: passwordField.input){
            passwordField.isValidationHidden = false
            x = false
        }else{
            passwordField.isValidationHidden = true
        }
        if (confirmpasswordField.input != passwordField.input || confirmpasswordField.input.isEmpty || confirmpasswordField.input == ""){
            confirmpasswordField.isValidationHidden = false
            x = false
        }else{
            confirmpasswordField.isValidationHidden = true
        }
        
        if !termsIsSelected{
            textColorChange = true
            x = false
        }else{
            textColorChange = false
        }
        
        
        return x
    }
}



func Check(fieldText: String) -> Bool {
    if fieldText == "" || fieldText.isEmpty {
        return false
    } else {
        return true
    }
}

func validateField(_ field: CustomTFieldState, x: inout Bool) {
    if !Check(fieldText: field.input) {
        field.isValidationHidden = false
        x = false
    }else{
        field.isValidationHidden = true
    }
}

func validateEmail(_ field: CustomTFieldState, x: inout Bool) {
    if !isEmailValid(text: field.input).0 {
        field.isValidationHidden = false
        x = false
    }else{
        field.isValidationHidden = true
    }
}

func validatePhone(_ field: CustomTFieldState, x: inout Bool) {
    if !isNumberValid(text: field.input).0 {
        field.isValidationHidden = false
        x = false
    }else{
        field.isValidationHidden = true
    }
}


