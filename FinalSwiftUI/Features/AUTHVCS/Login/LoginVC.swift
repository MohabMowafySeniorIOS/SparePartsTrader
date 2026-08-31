import SwiftUI
//import Combine


struct LoginVC: View {
   
    // MARK: - Phone State
    
    @State private var phoneInput = ""
    @State private var phoneValidationLabel = "phone_number_required".localized
    @State private var isLabelHiddenPhone = true
    @State private var isRequiredPhone = true
    @State private var showNumberAlert: Bool = false
    
    // MARK: - Password State
    
    @State private var passwordInput = ""
    @State private var passwordValidationLabel = "password_required".localized
    @State private var isLabelHiddenPassword = true
    @State private var isRequiredPassword = true
    @State private var showPasswordAlert: Bool = false
    @State private var isForgetPassw = false
    
    // MARK: - View
    @ObservedObject var viewModel: LoginViewModel
    init(viewModel: LoginViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            mainContent
                .background(
                    Color(Color.backGroundColor)
                )
        }.onAppear {
            if AuthService.userData?.token != nil {
                viewModel.showGuest()
            }
        }
    }
   
    // MARK: - Main Content
    
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 16) {
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
            textFields
            buttonSection
        }
    }
    
    private var textFields: some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text("inser_phone_password".localized)
                        .font(.custom(AppFont.Regular.rawValue, size: 16))
                        .foregroundColor(Color.TitleColor)
                    Spacer()
                }
                    
                CustomMobileTextField(
                    text: $phoneInput,
                    Validation_label: $phoneValidationLabel,
                    is_validation_label: $isLabelHiddenPhone,
                    isPhoneNumber: true,
                    isSelectable: false,
                    showTitle: false,
                    placeholder: "phone_placeholder".localized
                )
                
                CustomePasswordTF(
                    text: $passwordInput,
                    title_label: "",
                    Validation_label: $passwordValidationLabel,
                    is_validation_label: $isLabelHiddenPassword,
                    isSelectable: false,
                    showTitle: false,
                    placeholder: "password_placeholder".localized
                )
               
            }
            forgetButton
        }
        
    }
    
    private var forgetButton: some View {
        Text("forgot_password".localized)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.custom(AppFont.Regular.rawValue, size: 14))
            .foregroundColor(Color.MainColor)
            .onTapGesture {
                viewModel.showPhone()
            }
    }
    
    // MARK: - Button Section
    
    private var buttonSection: some View {
        VStack(spacing: 12) {
            ContentButtonView(title: "login_button".localized) {
                if isValid() {
                    viewModel.fetchUsers(urlEndPoint: .Login, methodType: .post, parameters: .init(auth: phoneInput, password: passwordInput, device_token: Helper.getFcmtoken() ?? "", type: "ios"))
                }
            }
            .padding(.horizontal)
            .padding(.horizontal)
            
            CustomeButtonWithBorderColor(title: "register_button".localized) {
                viewModel.showRegister()
            }
            .padding(.horizontal)
            .padding(.horizontal)
            
         
        }
    }
    
    func isValid() -> Bool {
        var isValid = true
        if !isNumberValid(text: phoneInput).0{
            isLabelHiddenPhone = false
            isValid = false
        }else{
            isLabelHiddenPhone = true
        }
        if !isPasswordValid(password: passwordInput).0{
            isLabelHiddenPassword = false
            
            isValid = false
        }else{
            isLabelHiddenPassword = true
        }
        
        return isValid
    }
}

