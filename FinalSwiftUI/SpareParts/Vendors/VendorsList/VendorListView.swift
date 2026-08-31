//
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//

import SwiftUI

struct FilterObject {
     var isNew: Bool?
     var isFar: Bool?
     var isBest: Bool?
}

struct VendorListView: View {
    @State var isVendorMenu: Bool = false
    @State var goToCountryAndCity: Bool = false
    @ObservedObject private var viewModel: VendorListViewModel
    @Binding var selectedTab: Int
    
//    @State var isNew: Bool?
//    @State var isFar: Bool?
//    @State var isBest: Bool?
    init(viewModel: VendorListViewModel,selectedTab: Binding<Int>) {
        _selectedTab = selectedTab
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
        mainContent
            .background(
                Color(Color.backGroundColor)
            )
            
        
        
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        
        VStack{
            AppHeaderView(Title: "Vendors List".localized,hideBackButton: true) {}
            searchView
            filterView
            Spacer()
            ShowViewState(state: viewModel.state) { Model in
                vendorList
            }
            
            handleNavigation
            Spacer()
        }
    }
    
    private var searchView: some View {
        HomeSearchBar(searchFieldText: $viewModel.fieldText, searchAction: {
            
        })
        .padding(.horizontal)
    }
    
    private var filterView: some View {
        HStack{
            Spacer()
            
            Image(systemName: "list.bullet")
                .foregroundStyle(Color.CBlack)
                .font(.system(size: 25))
                .onTapGesture {
                    isVendorMenu = true
                }
                .sheet(isPresented: $isVendorMenu) {
                    VendorsMenuFilterCardView(filterObject: $viewModel.filterObject, isVendorMenu: $isVendorMenu)
                        .presentationDetents([.height(310)])
                }
            
            
            Image(systemName: "slider.horizontal.3")
                .foregroundStyle(Color.CBlack)
                .font(.system(size: 25))
                .onTapGesture {
                    goToCountryAndCity = true
                }
        } .padding(.horizontal)
    }
    
    private var vendorList: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ],
                spacing: 8   // 👈 المسافة بين الصفوف
            ) {
                ForEach(viewModel.vendorData.indices, id: \.self) { index in
                    let vendor = viewModel.vendorData[index]
                    VendorCardWithLocation(vendor: vendor, orderNow: {
                        viewModel.coordinator.vendorDetails(rating: vendor.ratingAvg ?? 0.0, vendorId: "\(vendor.id)")
                    }, openLocation: {
                        viewModel.openGoogleMaps(lat: vendor.latitude ?? 0.0, lng: vendor.longitude ?? 0.0)
                    }, pressFavourite: {
                        viewModel.handleFavourite(traderModel: vendor)
                    })
                }
                
            } .padding(.horizontal)
        }
        
        .padding(.top)
        
        
    }
    
    private var handleNavigation: some View {
        NavigationLink("",
                       destination:  ChooseCountryAndCityView(viewModel: ChooseCountryAndCityViewModel(), countryAndCities: $viewModel.countryAndCities), isActive: $goToCountryAndCity)
        .navigationBarHidden(true)
        .hidden()
    }
}

