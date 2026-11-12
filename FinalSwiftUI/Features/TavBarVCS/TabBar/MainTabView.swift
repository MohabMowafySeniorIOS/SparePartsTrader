import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 3
    private let coordinator: MainCoordinator
    @StateObject private var homeViewModel: VendorHomeViewModel
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        _homeViewModel = StateObject(wrappedValue: VendorHomeViewModel(coordinator: coordinator))
    }

    var body: some View {
            ZStack {
                
                TabView(selection: $selectedTab) {
                  
                    HomeVendor(viewModel: homeViewModel, selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("home".localized)
                        }
                        .tag(3)
                   
                  
                    WalletMainView(viewModel: WalletViewModel(coordinator: coordinator), isShowBakButton: true) .tabItem {
                        Image.order
                        Text("Wallet".localized)
                    }
                    .tag(2)
                   
                        MyOrdersView(viewModel: MyOrdersViewModel(coordinator: coordinator), selectedTab: $selectedTab)
                            .tabItem {
                                Image.order
                                Text("orders".localized)
                            }
                            .badge(homeViewModel.awaitingOfferCount)
                            .tag(1)
                        
                      
                    
                   
                    
                    SidMenueVC(viewModel: sidMenueViewModel(coordinator: coordinator), selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: "line.horizontal.3")
                            Text("menu".localized)
                        }
                        .tag(0)
                        
                  
                }
                

            }
            .accentColor(Color.MainColor)
            .onChange(of: selectedTab) { newTab in
                if newTab == 3 {
                    homeViewModel.getHomeData()
                    homeViewModel.getUnreadNotificationsCount()
                }
            }

    }
}
