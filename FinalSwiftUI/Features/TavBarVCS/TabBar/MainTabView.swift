import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 3
    private let coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
            ZStack {
                
                TabView(selection: $selectedTab) {
                  
                    HomeVendor(viewModel: VendorHomeViewModel(coordinator: coordinator), selectedTab: $selectedTab)
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

    }
}
