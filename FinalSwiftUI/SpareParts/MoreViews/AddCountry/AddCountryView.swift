//
//  AddCountryView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 16/07/2025.
//

import SwiftUI

struct AddCountryView: View {
    
    @State private var isCountryDropDownActive: Bool = false
    @State private var isCityDropDownActive: Bool = false
    @State private var isRegionDropDownActive: Bool = false
   
    @State private var rotation: Double = 0
    @State private var isLoading = true
    
    @ObservedObject private var viewModel: VendorDetailsViewModel
    init(viewModel: VendorDetailsViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            mainContent
        }

    }
   
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack{
            AppHeaderView(Title: "filer") {
                viewModel.coordinator.disMiss()
            }
            ScrollView {
                DropDownBar(isDropDownActive: $isCountryDropDownActive, title: "country")
                if isCountryDropDownActive {
                    VStack(alignment: .leading){
                        ForEach(0..<10) { item in
                            HStack{
                                SpareCityFilterBox(isBoxActive: false, city: "saui")
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                DropDownBar(isDropDownActive: $isCityDropDownActive, title: "city")
                .onTapGesture {
                    isCityDropDownActive.toggle()
                }
                
                if isCityDropDownActive {
                    VStack(alignment: .leading){
                        ForEach(0..<10) { item in
                            HStack{
                                SpareCityFilterBox(isBoxActive: false, city: "saui")
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                DropDownBar(isDropDownActive: $isRegionDropDownActive, title: "region")
                    .onTapGesture {
                        isRegionDropDownActive.toggle()
                    }
                
                if isRegionDropDownActive {
                    VStack(alignment: .leading){
                        ForEach(0..<10) { item in
                            HStack{
                                SpareCityFilterBox(isBoxActive: false, city: "saui")
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                HStack{
                    SimpleSpareButton(buttonTitle: "add", action: {
                        
                    }, widthValue: 300, heightValue: 45)
                }
                .padding(.horizontal)
                .padding(.top)

            }
        }

        
    }
}

