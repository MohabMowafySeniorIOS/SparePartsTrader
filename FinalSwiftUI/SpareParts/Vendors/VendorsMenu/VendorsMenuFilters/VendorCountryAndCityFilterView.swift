//
//  VendorCountryAndCityFilterView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import SwiftUI

struct VendorCountryAndCityFilterView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isCountryDropDownActive: Bool = false
    @State private var isCityDropDownActive: Bool = false
    
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
                dismiss()
            }
            ScrollView {
                HStack{
                    Text("country".localized)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isCountryDropDownActive ? 180 : 0))
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle())
                )
                .padding()
                .onTapGesture {
                    isCountryDropDownActive.toggle()
                }
                
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
                
                HStack{
                    Text("city".localized)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isCountryDropDownActive ? 180 : 0))
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle())
                )
                .padding()
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
                
                HStack{
                    SmallButtonComponent(action: {
                        
                    }, title: "save")
                    Spacer()
                    SmallButtonWithBorder(action: {
                        
                    }, title: "reset")
                }
                .padding(.horizontal)
                .padding(.top)

            }
        }

        
    }
}

