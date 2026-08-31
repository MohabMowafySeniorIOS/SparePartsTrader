//
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//

import SwiftUI

struct VendorListOrderView: View {
    @Environment(\.dismiss) var dismiss
    @State private var fieldText: String = ""
    @State var isVendorMenu: Bool = false
    @Binding var vendorDetails: Trader?
    @ObservedObject private var viewModel: VendorListOrderViewModel
    @State var isNew: Bool?
    @State var isFar: Bool?
    @State var isBest: Bool?
    init(viewModel: VendorListOrderViewModel,vendorDetails: Binding<Trader?>) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self._vendorDetails = vendorDetails
    }
    var body: some View {
        
       
            mainContent
                .navigationBarHidden(true)
        
        
        
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        
        VStack{
            AppHeaderView(Title: "Vendors List".localized) {
                dismiss()
            }
            
            searchView
            filterView
            ShowViewState(state: viewModel.state) { Model in
            vendorList
            }
        }
    }
    
    private var searchView: some View {
        HomeSearchBar(searchFieldText: $fieldText, searchAction: {
            
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
        } .padding(.horizontal)
    }
    
    private var vendorList: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(
                columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                    ForEach(viewModel.vendorData?.data ?? []){ vendor in
                        VendorCardWithLocation(vendor: vendor, orderNow: {
                            vendorDetails = vendor
                            dismiss()
                            
                        }, openLocation: {
                            
                            viewModel.openGoogleMaps(lat: vendor.latitude ?? 0.0, lng: vendor.longitude ?? 0.0)
                        }, pressFavourite: {
                            viewModel.handleFavourite(traderModel: vendor)
                        })
                    }
                    .frame(maxWidth: 150)
                }
        }
        .padding(.top)
        .padding(.horizontal, 12)
        
    }
}

