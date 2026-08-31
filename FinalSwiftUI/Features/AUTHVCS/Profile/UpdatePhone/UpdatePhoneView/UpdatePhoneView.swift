import SwiftUI
//import Combine


struct UpdatePhoneView: View {
    
    @State private var phoneInput = ""
    @State private var phoneValidationLabel = "phone_number_required".localized
    @State private var isLabelHiddenPhone = true
    @State private var isRequiredPhone = true
    @State private var showNumberAlert: Bool = false
    
    @ObservedObject var viewModel: UpdatePhoneViewModel
    init(viewModel: UpdatePhoneViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ShowViewState(state: viewModel.state, content: { Model in
            mainContent .background(
                Color(Color.backGroundColor)
            )
        })
    }
 
    // MARK: - Main Content
    
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                AuthHeaderView(Title: "") {
                    viewModel.disMiss()
                }
                VStack(spacing: 51) {
                    logoSection
                    formSection
                }
            }
            .padding(16)
        }
        .mask(RoundedRectangle(cornerRadius: 0))
    }
    
    // MARK: - Logo Section
    
    private var logoSection: some View {
        VStack(spacing: 35) {
            Image.Splashlogo
                .resizable()
                .logoSize()
            
            Text("login_title".localized)
                .font(.custom(AppFont.bold.rawValue, size: 16))
                .foregroundColor(Color.TitleColor)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Form Section
    
    private var formSection: some View {
        VStack(spacing: 120) {
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
            }
            
            buttonSection
        }
    }
    
    // MARK: - Button Section
    
    private var buttonSection: some View {
        VStack(spacing: 12) {
            ContentButtonView(title: "login_button".localized) {
                var isValid = true
                if !isNumberValid(text: phoneInput).0{
                    isLabelHiddenPhone = false
                    isValid = false
                }else{
                    isLabelHiddenPhone = true
                }
               
                if isValid {
                    viewModel.fetchUsers(urlEndPoint: .updatePhone, methodType: .post, parameters: .init(auth: phoneInput))
                }
                
            }
            .padding(.horizontal)
            .padding(.horizontal)
        }
    }
}

