import StoreKit
import SwiftUI

enum SideMenuSelectedItem {
    
}

struct SidMenueVC: View {
    @State private var showDeleteConfirm = false
    @State private var showLogoutConfirm = false
    @State private var showAlert = false
    @State private var showShareSheet = false
    private var isFirst = false
    @State private var savedProfileImage: UIImage? = nil
    let normaltextinsideSideMenuColor: Color = Color.SecondaryColor
    @ObservedObject var viewModel: sidMenueViewModel
    @State var updateAvatar = false
    @Binding var selectedTab: Int
    init(viewModel: sidMenueViewModel,selectedTab: Binding<Int>) {
        _selectedTab = selectedTab
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            mainContent
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        
        
        VStack(spacing: 30) {
            if updateAvatar {
                headerView
            }
            
            scrollView
            
        } .padding(.leading, 16)
            .frame(maxHeight: .infinity)
            .background(Color.backGroundColor)
        // .shadow(radius: 5)
        //.transition(.move(edge: .leading))
        
        
            .onAppear {
                updateAvatar = true
                //  isFirst = false
                if let imageData = UserDefaults.standard.data(forKey: "profileImage"),
                   let image = UIImage(data: imageData) {
                    savedProfileImage = image
                }
            }
            .onDisappear {
                updateAvatar = false
            } .confirmActionAlert(
                isPresented: $showLogoutConfirm,
                title: "logout_confirm_title".localized,
                message: "logout_confirm_message".localized,
                onConfirm: {
                    viewModel.logOut()
                }
            )
            .confirmActionAlert(
                isPresented: $showDeleteConfirm,
                title: "delete_account_confirm_title".localized,
                message: "delete_account_confirm_message".localized,
                onConfirm: {
                    viewModel.DeleteAccount()
                }
            )
        
    }
    
    private var headerView: some View {
        HStack(alignment: .center) {
            if let image = savedProfileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            } else if AuthService.userData?.token != nil {
                RemoteImageView(imageUrl: AuthService.userData?.avatar?.path ?? "")
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            }
            else {
                Image("portrait-white-man-isolated")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            }

            if AuthService.userData?.full_name != nil{
                Text(AuthService.userData?.full_name ?? "")
                    .font(addFont(fontType: .bold, size: 17))
                    .foregroundStyle(Color.CBlack)
            }else{
                Text("user_name".localized)
                    .font(addFont(fontType: .bold, size: 17))
                    .foregroundStyle(Color.CBlack)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        .padding(.trailing)
        .onTapGesture {
            if AuthService.userData?.token != nil {
                viewModel.coordinator.showProfile()

            }else {
                showAlert = true
            }
        }
        .navigationBarHidden(true)
    }
    
    
    
    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 0) {
                if AuthService.userData?.token != nil {
                   Businessـfile

                }


                myMessages
                settingView
                FAQView
                pagesView
                contactUsView
                shareView
                rateView
                logOutView
                deleteView
                versionView

            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.CWhite)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
            .padding(.trailing)

            Spacer()
        }
    }
    
 
    
    private var Businessـfile: some View {
        SidMEnueView(
            title: "Business File".localized,
            textColor: normaltextinsideSideMenuColor,
            image: "Path 38422"
        )
        .onTapGesture {
            self.viewModel.coordinator.showMyFileBusniss()
        }
    }
    
   
    
    private var myWallet: some View {
        SidMEnueView(
            title: "menu_wallet".localized,
            textColor: normaltextinsideSideMenuColor, image: "wallet-2"
        )
        .onTapGesture {
            self.viewModel.coordinator.showWallet()
        }
    }
    
    private var myMessages: some View {
        SidMEnueView(
            title: "menu_messages".localized,
            textColor: normaltextinsideSideMenuColor, image: "notes"
        )
        .onTapGesture {
            self.viewModel.coordinator.showMessages()
        }
    }
    
    private var settingView: some View {
        SidMEnueView(
            title: "menu_settings".localized,
            textColor: normaltextinsideSideMenuColor,
            image: "setting"
        )
        .onTapGesture {
            self.viewModel.coordinator.showSettings()
        }
    }
    
    private var FAQView: some View {
        SidMEnueView(
            title: "menu_faq".localized,
            textColor: normaltextinsideSideMenuColor, image: "Frequently asked questions"
        )
        .onTapGesture {
            self.viewModel.showFAQ()
        }
    }
    
    private var pagesView: some View {
        ForEach(viewModel.pagesArray,id: \.self) { item in
            
            SidMEnueView(
                title: item.localized,
                textColor: normaltextinsideSideMenuColor,
                image: getImage(page: item)
            )
            .onTapGesture {
                self.viewModel.coordinator.showAboutUs(page: item)
            }
        }
    }
    
    func getImage(page: String) -> String {
        var image = ""
        if page == "about" {
            image = "About the app"
        }else if page == "terms" {
            image = "Terms and Conditions"
        }
        else if page == "privacy" {
            image = "privacy policy"
        }
        
        return image
    }
    
    private var contactUsView: some View {
        SidMEnueView(
            title: "menu_contact".localized,
            textColor: normaltextinsideSideMenuColor,
            image: "call me"
        )
        .onTapGesture {
            self.viewModel.coordinator.showContact()
        }
    }
    
    private var shareView: some View {
        SidMEnueView(
            title: "menu_share".localized,
            textColor: normaltextinsideSideMenuColor, image: "Share"
        )
        .onTapGesture {
            self.showShareSheet = true
        }
    }
    
    private var rateView: some View {
        SidMEnueView(
            title: "menu_rate".localized,
            textColor: normaltextinsideSideMenuColor, image: "App evaluation"
        )
        .onTapGesture {
            if let scene = UIApplication.shared.connectedScenes
                .first as? UIWindowScene
            {
                SKStoreReviewController.requestReview(in: scene)
            }
            //                                    if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review") {
            //                                        UIApplication.shared.open(url)
            //                                    }
        }
    }
    
    private var logOutView: some View {
        SidMEnueView(
            title: AuthService.userData?.token == nil ? "Log In".localized : "menu_logout".localized, textColor: Color.CRed, 
            image: AuthService.userData?.token == nil ? "Log in" : "log out"
        )
        .onTapGesture {
            if AuthService.userData?.token == nil {
                viewModel.showlogOut()
            }else {
                showLogoutConfirm = true
            }
        }
        .foregroundColor(Color.red)
    }
    
    @ViewBuilder
    private var deleteView: some View {
        if AuthService.userData?.token != nil {
            SidMEnueView(
                title: "menu_delete_account".localized,
                textColor: Color.CRed,
                image: "delet account"
            )
            .onTapGesture {
                showDeleteConfirm = true
              //  viewModel.DeleteAccount()
            }
            .foregroundColor(Color.red)
        }
    }
    
    private var versionView: some View {
        SidMEnueView(
            title: "menu_app_version".localized
            + " \(appVersion ?? "")",
            textColor: normaltextinsideSideMenuColor,
            image: "App version"
        )
    }
}


