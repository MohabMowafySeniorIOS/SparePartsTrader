//
//  AddMerchantView.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//

import Foundation
import SwiftUI

enum chooseImage {
    case logoImageSelected
    case attach1ImageSelected
    case attach2ImageSelected
    case attach3ImageSelected
    case commercialImageSelected
}

struct AddMerchantView: View {
   
    var userModel:LoginData?
    @State private var selectedImage: chooseImage? = nil // <-- FIXED HERE
    
    @State private var pickedImage: UIImage? = nil
    @State var currentImage: String?
    @State private var pickedImages: [VendorImage] = []
    @State private var isImagePickerValid: Bool = true
    
    @State private var arabicAboutBody : String = ""
    @State private var isarabicAboutBodyFieldValid: Bool = true
    
    @State private var englishAboutBody : String = ""
    @State private var isenglishAboutBodyFieldValid: Bool = true
    
    @StateObject var arabiNameField            = CustomTFieldState(validationLabel: "validation_required".localized)
    
    @StateObject var EnglishnameField            = CustomTFieldState(validationLabel: "validation_required".localized)
    
    @StateObject var BanknameField            = CustomTFieldState(validationLabel: "validation_required".localized)
    
    @StateObject var CommercialNumberField            = CustomTFieldState(validationLabel: "validation_required".localized)
  
    @StateObject var BenefetaryNumberField            = CustomTFieldState(validationLabel: "validation_required".localized)
    
   
    @StateObject var AccountNumberField            = CustomTFieldState(validationLabel: "validation_required".localized)
    
    
    @StateObject var IBANNumberField            = CustomTFieldState(validationLabel: "validation_required".localized)
   
    
    @State private var showImagePicker: Bool = false
    
    @State private var termsIsSelected = false
    
    @State private var naviToOtp: Bool = false
    @State private var checkboxalert: Bool = false
    @State private var textColorChange: Bool = false
    
    @State var is_country_validation_label: Bool = true
    @State var Validation_country_label: String = "Country Is Required".localized
    
    @State var is_city_validation_label: Bool = true
    @State var Validation_city_label: String = "City Is Required".localized
    
    
    @State private var showErrors = false
    
    @State var isTerms: Bool = false
    @State var termsMandatory: Bool = false
    
    var address = "123 Main Street"
    var lat = "30.0444"
    var lng = "31.2357"
    
   @ObservedObject var viewModel: AddMerchantViewModel
    init(viewModel: AddMerchantViewModel,userModel: LoginData?) {
        
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.userModel = userModel
       
    }
    
    
    
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            VStack(spacing: 0) {
                AppHeaderView(Title: "commercial_request_title") {
                    viewModel.onDismiss()
                }
                scrollView
                Spacer()
                updateButton
            }
        }
        .onAppear {
            fillData()
            
           
        }
        .background(Color.backGroundColor)
        .sheet(isPresented: $showImagePicker, onDismiss: {
            if let image = pickedImage {
                
                if selectedImage == .logoImageSelected {
                    viewModel.LogoAttachMent(file: image, parameters: .init(media_type:"image",model: "Trader",model_id:"\(userModel?.trader?.logo?.modelID ?? "0")",option: userModel?.trader?.logo?.option ?? "",is_single: "1",model_type: userModel?.trader?.logo?.modelType ?? ""), imageType: .logoAttachMent)
                }else if selectedImage == .attach1ImageSelected {
                    viewModel.LogoAttachMent(file: image, parameters: .init(media_type:"image",model: "Trader",model_id:"\(userModel?.trader?.logo?.modelID ?? "0")",option: "trader_images",is_single: "0",model_type: userModel?.trader?.logo?.modelType ?? ""), imageType: .image1AttachMent)
                }else if selectedImage == .attach2ImageSelected {
                    viewModel.LogoAttachMent(file: image, parameters: .init(media_type:"image",model: "Trader",model_id:"\(userModel?.trader?.logo?.modelID ?? "0")",option: "trader_images",is_single: "0",model_type: userModel?.trader?.logo?.modelType ?? ""), imageType: .image2AttachMent)
                }else if selectedImage == .attach3ImageSelected {
                    viewModel.LogoAttachMent(file: image, parameters: .init(media_type:"image",model: "Trader",model_id:"\(userModel?.trader?.logo?.modelID ?? "0")",option: "trader_images",is_single: "0",model_type: userModel?.trader?.logo?.modelType ?? ""), imageType: .image3AttachMent)
                }
                else if selectedImage == .commercialImageSelected {
                    viewModel.LogoAttachMent(file: image, parameters: .init(media_type:"image",model: "Trader",model_id:"\(userModel?.trader?.commercial_register_image?.modelID ?? "0")",option: userModel?.trader?.commercial_register_image?.option ?? "",is_single: "1",model_type: userModel?.trader?.commercial_register_image?.modelType ?? ""), imageType: .commercialAttachMent)
                }
               
            }
        }) {
            ImageOnePicker(image: $pickedImage)
        }
    }
    
    func fillData(){
        viewModel.logoAttachMent = userModel?.trader?.logo
        viewModel.commercialAttachMent = userModel?.trader?.commercial_register_image
        if (userModel?.trader?.images?.count ?? 0) > 0 {
            viewModel.image1AttachMent = userModel?.trader?.images?[0]
        }
        if (userModel?.trader?.images?.count ?? 0) > 1 {
            viewModel.image2AttachMent = userModel?.trader?.images?[1]
        }
        if (userModel?.trader?.images?.count ?? 0) > 2 {
            viewModel.image3AttachMent = userModel?.trader?.images?[2]
        }
        
        viewModel.logoAttachMent = userModel?.trader?.logo
        viewModel.logoAttachMent = userModel?.trader?.logo
        arabiNameField.input = userModel?.trader?.trade_name_ar ?? ""
        EnglishnameField.input = userModel?.trader?.trade_name_en ?? ""
        BenefetaryNumberField.input = userModel?.trader?.bank_account_name ?? ""
        BanknameField.input = userModel?.trader?.bank_name ?? ""
        CommercialNumberField.input = userModel?.trader?.commercial_register ?? ""
        AccountNumberField.input = userModel?.trader?.bank_account_number ?? ""
        
        IBANNumberField.input = userModel?.trader?.bank_iban ?? ""
        
        arabicAboutBody = userModel?.trader?.description_ar ?? ""
        englishAboutBody = userModel?.trader?.description_en ?? ""
        
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                textFields
            }
            .padding()
        }
    }
    
    private var textFields: some View {
        VStack(spacing:16) {
            
            CustomTextField(
                text: $arabiNameField.input,
                Validation_label: $arabiNameField.validationLabel,
                is_validation_label: $arabiNameField.isValidationHidden,
                is_title_label: true,
                textType: .arabicTraderName
            )
            
            CustomTextField(
                text: $EnglishnameField.input,
                Validation_label: $EnglishnameField.validationLabel,
                is_validation_label: $EnglishnameField.isValidationHidden,
                is_title_label: true,
                textType: .englishTraderName
            )
            imagesView
            UploadImagesView(logoImage: viewModel.logoAttachMent?.path ?? "", attach1Image: viewModel.image1AttachMent?.path ?? "", attach2Image: viewModel.image2AttachMent?.path ?? "", attach3Image: viewModel.image3AttachMent?.path ?? "",logoAction: {
               selectedImage = .logoImageSelected
                showImagePicker = true
            }, attach1: {
              selectedImage = .attach1ImageSelected
                showImagePicker = true
            }, attach2: {
                selectedImage = .attach2ImageSelected
                showImagePicker = true
            }, attach3: {
                selectedImage = .attach3ImageSelected
                showImagePicker = true
            },logoDisMiss: {
                viewModel.destoryAttach(id: viewModel.logoAttachMent?.id ?? "") {
                    viewModel.logoAttachMent = nil
                }
                
            },DisMiss1: {
                viewModel.destoryAttach(id: viewModel.image1AttachMent?.id ?? "") {
                    viewModel.image1AttachMent = nil
                }
                
            },DisMiss2: {
                viewModel.destoryAttach(id: viewModel.image2AttachMent?.id ?? "") {
                    viewModel.image2AttachMent = nil
                }
                
            },DisMiss3: {
                viewModel.destoryAttach(id: viewModel.image3AttachMent?.id ?? "") {
                    viewModel.image3AttachMent = nil
                }
                
            })
            arabicAbouttextView
            englishAbouttextView
        
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
            
            addAddressView
            
            CustomTextField(
                text: $CommercialNumberField.input,
                Validation_label: $CommercialNumberField.validationLabel,
                is_validation_label: $CommercialNumberField.isValidationHidden,
                is_title_label: true,
                textType: .commercialNumber
            )
            VStack {
                HStack {
                    CustomLabel_text(imageName: "", labelText: "Attach a copy of the commercial registration.".localized)
                    Spacer()
                }
                UploadBox(size: 201, image: viewModel.commercialAttachMent?.path ?? "", onDisMiss: {
                    
                    viewModel.destoryAttach(id: viewModel.commercialAttachMent?.id ?? "") {
                        viewModel.commercialAttachMent = nil
                    }
                })
                    .onTapGesture {
                       selectedImage = .commercialImageSelected
                        showImagePicker = true
                }
            }
           
            CustomTextField(
                text: $BanknameField.input,
                Validation_label: $BanknameField.validationLabel,
                is_validation_label: $BanknameField.isValidationHidden,
                is_title_label: true,
                textType: .BankName
            )
            
            CustomTextField(
                text: $AccountNumberField.input,
                Validation_label: $AccountNumberField.validationLabel,
                is_validation_label: $AccountNumberField.isValidationHidden,
                is_title_label: true,
                textType: .BankAccount
            )
            
            CustomTextField(
                text: $BenefetaryNumberField.input,
                Validation_label: $BenefetaryNumberField.validationLabel,
                is_validation_label: $BenefetaryNumberField.isValidationHidden,
                is_title_label: true,
                textType: .benefiterName
            )
            
            CustomTextField(
                text: $IBANNumberField.input,
                Validation_label: $IBANNumberField.validationLabel,
                is_validation_label: $IBANNumberField.isValidationHidden,
                is_title_label: true,
                textType: .IBAN
            )
         
            tesrmsView
        }
    }
    @ViewBuilder
    private var imagesView: some View {
        if let image = currentImage {
            RemoteImageView(imageUrl: image)
                .frame(width: 200, height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.SecondaryColor, lineWidth: 2)
                )
                .clipped()
                .cornerRadius(8)
                .padding(.bottom,10)
        }
        HorizontalImageScroller(images: pickedImages, currentImage: $currentImage)
    }
  
    @ViewBuilder
    private var addAddressView: some View {
       
        HStack {
            Text("Locate the site on the map".localized)
            Image("darkLocation")
            Spacer()
        }.onTapGesture {
            viewModel.onAddress()
        }
    }
    
    private var updateButton: some View {
        ContentButtonView(title: "register_submit_button".localized) {
            if isValid() {
                var params = BaseParameters()
                params.trade_name_ar = arabiNameField.input
                params.trade_name_en = EnglishnameField.input
                params.description_ar = arabicAboutBody
                params.description_en = englishAboutBody
                params.country_id = "\(viewModel.selectedCcountry?.id ?? 0)"
                params.city_id = "\(viewModel.selectedCity?.id ?? 0)"
                params.address = address
                params.latitude = lat
                params.longitude = lng
                params.commercial_register = CommercialNumberField.input
                params.bank_name = BanknameField.input
                params.bank_account_name = BenefetaryNumberField.input
                params.bank_account_number = AccountNumberField.input
                params.bank_iban = IBANNumberField.input
                viewModel.completeProfile(parameters: params)
            }
        }.padding()
    }
    
    private var tesrmsView: some View {
        TermsView(
            isSelected: $isTerms, textColorChange: $termsMandatory
        )
        .onTapGesture {
            isTerms.toggle()
        }
    }
    
    private var arabicAbouttextView: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                Text("About the Commercial (in Arabic)".localized)
                    .font(addFont(fontType: .bold, size: 12))
                Spacer()
            }
            
            TextEditor(text: $arabicAboutBody)
                .frame(height: 120)
                .scrollContentBackground(.hidden)
                    .background(Color.CWhite)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
            
            
            if !isarabicAboutBodyFieldValid {
                HStack{
                    Text("validation_required".localized)
                        .font(addFont(fontType: .bold, size: 12))
                        .foregroundStyle(Color.CRed)
                    
                    Spacer()
                }
            }
        }
    }
    
    private var englishAbouttextView: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                Text("About the business (in English)".localized)
                    .font(addFont(fontType: .bold, size: 12))
                Spacer()
            }
            
            TextEditor(text: $englishAboutBody)
                .frame(height: 120)
                .scrollContentBackground(.hidden)   // مهم
                    .background(Color.CWhite)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
            
            
            if !isenglishAboutBodyFieldValid {
                HStack{
                    Text("validation_required".localized)
                        .font(addFont(fontType: .bold, size: 12))
                        .foregroundStyle(Color.CRed)
                    
                    Spacer()
                }
            }
        }
    }
    
    func isValid() -> Bool {
        var x: Bool = true
        
        validateField(arabiNameField,  x: &x)
        validateField(EnglishnameField,  x: &x)
        validateField(BanknameField,  x: &x)
        validateField(AccountNumberField,  x: &x)
        validateField(BenefetaryNumberField,  x: &x)
        validateField(IBANNumberField,  x: &x)
     
        if !Check(fieldText: viewModel.selectedCcountry?.name ?? ""){
            is_country_validation_label = false
            x = false
        }else{
            is_country_validation_label = true
        }
        if !Check(fieldText: viewModel.selectedCity?.name ?? ""){
            is_city_validation_label = false
            x = false
        }else{
            is_city_validation_label = true
            
        }
        
        if !Check(fieldText: arabicAboutBody){
            isarabicAboutBodyFieldValid = false
            x = false
        }else{
            isarabicAboutBodyFieldValid = true
           
        }
        if !Check(fieldText: englishAboutBody){
            isenglishAboutBodyFieldValid = false
            x = false
        }else{
            isenglishAboutBodyFieldValid = true
            
        }
       
        
        if !termsIsSelected{
            textColorChange = true
            
        }else{
            textColorChange = false
            x = false
        }
        
        print(x)
        return x
    }
    
}
struct InputField: View {
    
    let title: String
    @Binding var text: String
    var showError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PlainUIKitTextField(
                text: $text,
                placeholder: title.localized
            )
                .frame(height: 24)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(showError ? Color.red : Color.gray.opacity(0.3))
                )
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)

            if showError {
                Text("validation_required")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}
struct MultilineField: View {
    
    let title: LocalizedStringKey
    @Binding var text: String
    var showError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            ZStack(alignment: .topLeading) {
                
                TextEditor(text: $text)
                    .frame(height: 120)
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(showError ? Color.red : Color.gray.opacity(0.3))
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)

                if text.isEmpty {
                    Text(title)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
            }
            
            if showError {
                Text("validation_required")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}
import SwiftUI

struct UploadImagesView: View {
    var logoImage: String?
    var attach1Image: String?
    var attach2Image: String?
    var attach3Image: String?
    var logoAction:()->Void
    var attach1:()->Void
    var attach2:()->Void
    var attach3:()->Void
    
    var logoDisMiss:()->Void
    var DisMiss1:()->Void
    var DisMiss2:()->Void
    var DisMiss3:()->Void
  
    var body: some View {
        VStack(alignment: .trailing, spacing: 24) {
            
            HStack {
                CustomLabel_text(imageName: "", labelText: "Attach Logo".localized)
                Spacer()
            }
            
            UploadBox(size: 106, image: logoImage, onDisMiss: {
                logoDisMiss()
            })
                .onTapGesture {
                    logoAction()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            
            
            HStack {
                CustomLabel_text(imageName: "", labelText: "Attach Added Images".localized)
                Spacer()
            }
            
            
            // MARK: - Extra Images Grid
            HStack(spacing: 16) {
                UploadBox(size: 106, image: attach1Image, onDisMiss: {
                    DisMiss1()
                })
                    .onTapGesture {
                        attach1()
                    }
                UploadBox(size: 106, image: attach2Image, onDisMiss: {
                    DisMiss2()
                })
                    .onTapGesture {
                        attach2()
                    }
                UploadBox(size: 106, image: attach3Image, onDisMiss: {
                    DisMiss3()
                })
                    .onTapGesture {
                        attach3()
                    }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        
        .background(Color(Color.backGroundColor))
    }
}
struct UploadBox: View {
    
    let size: CGFloat
     var image: String?
    var onDisMiss: (() -> Void)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .frame(width: size, height: size)
            
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.28)
                .foregroundColor(.cyan)
            
            if let uiImage = image, uiImage.count > 0 {
                ZStack(alignment: .top) {
                    RemoteImageView(imageUrl: uiImage)
                        .frame(width: size, height: size)
                        .cornerRadius(16)
                        .scaledToFit()
                    HStack {
                      Image("close")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            onDisMiss()
                        }
                        Spacer()
                    }
                    
                    
                } .frame(width: size, height: size)
               
                
            }
        }
    }
}

