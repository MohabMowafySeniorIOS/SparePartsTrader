//
//  ProfileVC.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/9/25.
//

import Foundation
import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct ProfileVC: View {
    @State var is_country_validation_label: Bool = true
    @State var Validation_country_label: String = "Country Is Required".localized
    
    @State var is_city_validation_label: Bool = true
    @State var Validation_city_label: String = "City Is Required".localized
    
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isChangePassword = false
    
    @ObservedObject private var viewModel: ProfileViewModel
    init(viewModel: ProfileViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    @State private var nameInput = AuthService.userData?.full_name ?? ""
    @State private var name_title_label = "full_name".localized
    @State private var name_Validation_label = "name_required".localized
    @State private var isLabelHiddenname = true
    
    
    @State private var emailInput = AuthService.userData?.email ?? ""
    @State private var email_title_label = "email".localized
    @State private var email_Validation_label = "email_required".localized
    @State private var isLabelHiddenemail = true
    
    
    @State private var PhoneInput = (AuthService.userData?.phone ?? "").replacingOccurrences(of: "+966", with: "")
    @State private var Phone_Validation_label = "phone_number_required".localized
    @State private var isLabelHiddenPhone = true
    
    
    @State private var ValidationErr = ""
    @State private var showAlert = false
    
    @State private var termsIsSelected = false
    @State private var showImagePicker: Bool = false
    @State private var pickedImage: UIImage? = nil
    
    @State private var cityTapped: Bool = false
    
    
    var body: some View {
        mainContent
            .background(
                Color(Color.backGroundColor)
            )
            .onAppear {
                viewModel.getProfile()
            }
        
    }
    
    
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack {
            AppHeaderView(Title: "Profile".localized) {
                viewModel.disMiss()
            }
            ShowViewState(state: viewModel.state, content: { Model in
                scrollView
            })
            
            Spacer()
            showButtons
            
        }
        
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 51) {
                    userDataView
                    textFields
                }
                
                
            }.padding(16)
        }.mask(RoundedRectangle(cornerRadius: 0))
        
    }
    
    private var showButtons: some View {
        VStack(spacing:16) {
            changePasswordButton
            updateButton
            
        }.padding(16)
    }
    
    private var changePasswordButton: some View {
        ContentButtonView(title: "change_password".localized) {
            viewModel.coordinator.showUpdatePassword()
        }
    }
    
    private var updateButton: some View {
        CustomeButtonWithBorderColor(title: "save".localized) {
            isLabelHiddenname = false
            
            if isValid() {
                print(nameInput,emailInput,PhoneInput)
                viewModel.updateProfile(parameters: .init(full_name: nameInput,email: emailInput,city_id: "\(viewModel.selectedCity?.id ?? 0)",method: "PUT"))
            }
        }
    }
    
    private var userDataView: some View {
        VStack(spacing: 35) {
            if let selectedImage = pickedImage{
                ZStack(alignment:.bottomTrailing){
                    
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                    
                    Image(systemName: "camera.fill.badge.ellipsis")
                        .foregroundStyle(Color.MainColor)
                        .font(.system(size: 20))
                        .padding(.trailing,10)
                    
                }
                
            }else {
                ZStack(alignment: .bottomTrailing){
                    
                    if (viewModel.userModel?.avatar?.path ?? "") != "" {
                        ZStack(alignment: .top) {
                            RemoteImageView(imageUrl: viewModel.userModel?.avatar?.path  ?? "")
                            // .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                            if (viewModel.userModel?.avatar?.id ?? "") != "" {
                                HStack {
                                  Image("close")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        viewModel.destoryAttach(id: viewModel.userModel?.avatar?.id ?? "") {
                                            viewModel.userModel?.avatar = nil
                                        }
                                    }
                                    Spacer()
                                }
                            }

                            
                            
                        }.frame(width: 130, height: 130)
                       
                    }else {
                        Image.CamerICon
                    }
                    
                    
                    Image(systemName: "camera.fill.badge.ellipsis")
                        .foregroundStyle(Color.MainColor)
                        .font(.system(size: 20))
                        .padding(.trailing,10)
                }
                
            }
        }
        .onTapGesture {
            showImagePicker = true
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            if let image = pickedImage,
               let imageData = image.pngData() {
                viewModel.attachMents(file: image, parameters: .init(media_type:"image",model: "User",model_id:"\(AuthService.userData?.id ?? "")",option: "avatar",is_single: "1",model_type: AuthService.userData?.avatar?.model_type ?? ""))
            }
        }) {
            ImageOnePicker(image: $pickedImage)
        }
    }
    
    
    private var textFields: some View {
        VStack(spacing:16) {
            CustomTextField(text: $nameInput, Validation_label: $name_Validation_label, is_validation_label: $isLabelHiddenname, is_title_label: true, textType: .userNAme)
            
            VStack {
                CustomMobileTextField(text: $PhoneInput, Validation_label: $Phone_Validation_label, is_validation_label: $isLabelHiddenPhone, isPhoneNumber: true, isSelectable: false, showTitle: true, placeholder: "phone_number".localized).disabled(true)
                updatePhone
            }
            
            
            CustomTextField(text: $emailInput, Validation_label: $email_Validation_label, is_validation_label: $isLabelHiddenemail, is_title_label: true, textType: .Email)
            
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
            
            
        }
    }
    
    private var updatePhone: some View {
        Text("Edit Phone Number".localized)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.custom(AppFont.Regular.rawValue, size: 14))
            .foregroundColor(Color.MainColor)
            .onTapGesture {
                viewModel.coordinator.showPhoneScreen()
            }
    }
    
    func isValid() -> Bool {
        var x: Bool = true
        FieldChecker(text: nameInput, chVar: &x, labelHidden: &isLabelHiddenname)
        FieldChecker(text: PhoneInput, chVar: &x, labelHidden: &isLabelHiddenPhone)
        FieldChecker(text: emailInput, chVar: &x, labelHidden: &isLabelHiddenemail)
        
        if viewModel.selectedCity == nil {
            x = false
            is_city_validation_label = false
        }else {
            is_city_validation_label = true
        }
        
        if viewModel.selectedCcountry == nil {
            x = false
            is_country_validation_label = false
        }else {
            is_country_validation_label = true
        }
        
        return x
    }
}



func FieldChecker(text: String,chVar: inout Bool,labelHidden: inout Bool) -> Bool {
    if text.isEmpty || text == "" {
        labelHidden = false
        chVar = false
    }else{
        labelHidden = true
    }
    return true
}
