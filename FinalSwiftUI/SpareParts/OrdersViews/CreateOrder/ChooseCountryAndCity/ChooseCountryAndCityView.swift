//
//  AddCountryView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 16/07/2025.
//

import SwiftUI

struct ChooseCountryAndCityView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isCountryDropDownActive: Bool = false
    @State private var isCityDropDownActive: Bool = false
    
    @ObservedObject private var viewModel: ChooseCountryAndCityViewModel
    @Binding var countryAndCities: [CountryAndCitiesModel]
    
    init(viewModel: ChooseCountryAndCityViewModel,countryAndCities: Binding<[CountryAndCitiesModel]>) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self._countryAndCities = countryAndCities
    }
    var body: some View {
        mainContent
            .navigationBarHidden(true)
    }
    
    
    private var mainContent: some View {
        VStack{
            AppHeaderView(Title: "Choose Country And City".localized) {
                dismiss()
            }
            ShowViewState(state: viewModel.state) { Model in
                VStack {
                    scrollView
                    addButtonView
                }
                
            }
            
        }.background(
            Color(Color.backGroundColor)
        )
    }
    
    private var scrollView: some View {
        ScrollView {
            countriesView
            citiesView
            
        }
    }
    
    private var countriesView: some View {
        VStack {
            DropDownBar(isDropDownActive: $isCountryDropDownActive, title: "choose_car_category".localized)
                .onTapGesture {
                    isCountryDropDownActive.toggle()
                }
            if isCountryDropDownActive {
                VStack(alignment: .leading){
                    ForEach(viewModel.countryArray,id: \.id) { item in
                        HStack{
                            SpareCityFilterBox(isBoxActive: item.id == (viewModel.selectedCcountry?.id ?? 0), city: item.name ?? "")
                                .onTapGesture {
                                    viewModel.selectedCcountry = item
                                }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    //
    private var citiesView: some View {
        VStack {
            DropDownBar(isDropDownActive: $isCityDropDownActive, title: "choose_car_brand".localized)
                .onTapGesture {
                    isCityDropDownActive.toggle()
                }
            
            if isCityDropDownActive {
                VStack(alignment: .leading){
                    ForEach(viewModel.cityArray.indices) { index in
                        HStack{
                            SpareCityFilterBox(isBoxActive:(viewModel.cityArray[index].isSelected), city: viewModel.cityArray[index].name ?? "")
                                .onTapGesture {
                                    viewModel.cityArray[index].toggleSelected()
                                }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private var addButtonView: some View {
        HStack{
            SimpleSpareButton(buttonTitle: "add", action: {
                if let country = viewModel.selectedCcountry {
                    var cities = viewModel.cityArray.filter { $0.isSelected == true }
                    print(cities)
                    countryAndCities.append(CountryAndCitiesModel(country: country, cities: cities))
                    for item in countryAndCities {
                        print(item.country?.name, item.cities)
                    }
                    dismiss()
                }
                
            }, widthValue: 300, heightValue: 45)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
}



