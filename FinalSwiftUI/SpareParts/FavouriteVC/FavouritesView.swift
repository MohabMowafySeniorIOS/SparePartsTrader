import SwiftUI

struct FavouritsView: View {
    @Binding var selectedTab: Int
   
    @ObservedObject private var viewModel: FavouritsViewModel
    
    init(viewModel: FavouritsViewModel,selectedTab: Binding<Int>) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        
            mainContent
            .background(
                Color(Color.backGroundColor)
            )
            .onChange(of: selectedTab) { newTab in
                if newTab == 1 {
                    viewModel.getFavourite()
                }
           
            
        }
           
    }
    private var mainContent: some View {
            VStack {
                AppHeaderView(Title: "favourites".localized,hideBackButton: true) {}
                ShowViewState(state: viewModel.state) { Model in
                vendorList
                }
                Spacer()
            }
    }
    
    private var vendorList: some View {
        VendorsListView(vendors: viewModel.traders, orderNow: { vendor in
                viewModel.coordinator.vendorDetails(rating: vendor.ratingAvg ?? 0.0, vendorId: "\(vendor.id)")
            }, favouriteAction: {vendor in
                viewModel.handleFavourite(traderModel: vendor)
            })
    }
   
}

