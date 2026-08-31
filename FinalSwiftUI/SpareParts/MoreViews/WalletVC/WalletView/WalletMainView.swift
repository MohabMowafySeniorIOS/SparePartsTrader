import SwiftUI

enum transActionTypes {
    case deposit
    case withdrawal
    case fee_payment
    case fee_refund
    case commission
}

enum walletTab {
    case addition
    case usage
    case withDrawRequest
}

struct WalletMainView: View {
    @State private var transferImage: String?
    @State var selectedTab: walletTab = .addition
    @State var walletMoneyField: String = ""
    @State var naviToChargeWallet: Bool = false
    @State private var showReceipt = false
    @ObservedObject private var viewModel: WalletViewModel
    
    var isShowBakButton: Bool
    init(viewModel: WalletViewModel,isShowBakButton: Bool) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.isShowBakButton = isShowBakButton
    }
  
    var body: some View {
        ZStack {
                   
            mainContent
                .background(
                    Color(Color.backGroundColor)
                )
                   
                   if showReceipt {
                       ReceiptPopupView(
                           imageURL: transferImage ?? "",
                           showPopup: $showReceipt
                       )
                   }
               }
    }
    
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        
        VStack {
            headerView
           balanceView
            typesView
            ShowViewState(state: viewModel.state) { Model in
                scrollView
            }
            Spacer()
            
        }
        
    }
    
    private var headerView: some View {
        AppHeaderView(Title: "Wallet".localized,hideBackButton:isShowBakButton) {
            viewModel.disMiss()
        }
    }
    
    private var balanceView: some View {
        HStack {
            HStack(spacing: 10) {
                Image("Wallet-1")
                    .resizable()
                    .foregroundStyle(Color.MainColor)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 18)
                    .padding(10)
                    .background(
                        Circle().fill(Color.CWhite)
                    )
                    .overlay(
                        Circle().stroke(Color.CGray2, lineWidth: 1)
                    )

                Text(viewModel.balanceModel?.formatted_balance ?? "")
                    .font(addFont(fontType: .bold, size: 16))
                    .foregroundStyle(Color.CBlack)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.CGray2, lineWidth: 1)
                    )
            }

            Spacer()

            ContentButtonView(title: "Withdrawal of balance".localized) {
                viewModel.coordinator.showWithDraw()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)

    }
    
    private var typesView: some View {
        HStack(spacing: 16) {
            Text("addition".localized.capitalized)
                .underline(selectedTab == .addition)
                .foregroundStyle(selectedTab == .addition ? Color.MainColor : Color.CBlack)
                .font(.custom(AppFont.bold.rawValue, size: 16))
                .onTapGesture {
                    selectedTab = .addition
                    viewModel.getTransActions(type: "deposit", page: "1")
                }
           
//            Text("usage".localized.capitalized)
//                .underline(selectedTab == .usage)
//                .foregroundStyle(selectedTab == .usage ? .main : Color.CBlack)
//                .font(.custom(AppFont.bold.rawValue, size: 16))
//                .onTapGesture {
//                    selectedTab = .usage
//                    viewModel.getTransActions(type: "payment", page: "1")
//                }
            
         
            
            Text("wallet.withdraw_request".localized.capitalized)
                .underline(selectedTab == .withDrawRequest)
                .foregroundStyle(selectedTab == .withDrawRequest ? Color.MainColor : Color.CBlack)
                .font(.custom(AppFont.bold.rawValue, size: 16))
                .onTapGesture {
                    selectedTab = .withDrawRequest
                    viewModel.getWithDraw(page: "1")
                }
            
        }
        .padding()
       
        

    }
    
    private var scrollView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.walletModel.indices, id: \.self) { index in
                    let item = viewModel.walletModel[index]
                  
                    WalletBlockItem(
                        item: item,
                        itemIndex: index + 1,
                        selectedTab: $selectedTab,
                        banckDetailsTap: {
                            viewModel.coordinator.BanckAccountDetails(model: item)
                        },
                        imageTap: {
                            self.loadImage(urlString: item.transfer_image ?? "")

                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)
        }
    }
    
    func loadImage(urlString: String) {
        self.transferImage = urlString
        self.showReceipt = true
    }
}
struct ReceiptPopupView: View {
    
    let imageURL: String
    @Binding var showPopup: Bool
    
    var body: some View {
        
        ZStack {
            
            // الخلفية الشفافة
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showPopup = false
                }
            
            VStack(spacing: 20) {
                
                HStack {
                    
                    Button {
                        showPopup = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text("View conversion image".localized)
                        .font(.headline)
                    
                    Spacer()
                }
                
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxHeight: 350)
                .cornerRadius(12)
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 30)
        }
        .transition(.opacity)
        .animation(.easeInOut, value: showPopup)
    }
}
