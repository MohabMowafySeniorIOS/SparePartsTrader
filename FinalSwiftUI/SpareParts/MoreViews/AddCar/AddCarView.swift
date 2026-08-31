//
//  AddCountryView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 16/07/2025.
//

import SwiftUI

struct AddCarView: View {
    
    @State private var isCountryDropDownActive: Bool = false
    @State private var isCityDropDownActive: Bool = false
    @State private var isRegionDropDownActive: Bool = false
    @State private var isdateDropDownActive: Bool = false
    
    @State private var fieldText: String = ""
    @ObservedObject private var viewModel: AddCarViewModel
    
    @State var is_category_validation_label: Bool = true
    @State var is_brand_validation_label: Bool = true
    @State var is_model_validation_label: Bool = true
    @State var is_year_validation_label: Bool = true
    @State var is_chest_validation_label: Bool = true
 
    
    init(viewModel: AddCarViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        fieldText = viewModel.carModel?.chassis_number ?? ""
    }
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            mainContent
        }.background(
                Color(Color.backGroundColor)
            )
        
    }
    
    
    private var mainContent: some View {
        VStack{
            AppHeaderView(Title: "add_car".localized) {
                viewModel.disMiss()
            }
            scrollView
        }
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 8) {
                categoriesView
                if !is_category_validation_label {
                    validationLabel(label: "Please Select Category".localized)
                }
            }
            
            VStack(spacing: 8) {
                carBrandView
                if !is_brand_validation_label {
                    validationLabel(label: "Please Select Brand".localized)
                }
            }
            
            VStack(spacing: 8) {
                carModelView
                if !is_model_validation_label {
                    validationLabel(label: "Please Select Model".localized)
                }
            }
            
            VStack(spacing: 8) {
                yearsView
                if !is_year_validation_label {
                    validationLabel(label: "Please Select Year".localized)
                }
            }
            
            VStack(spacing: 8) {
                chestView
                if !is_chest_validation_label {
                    validationLabel(label: "Please Insert Chest Number".localized)
                }
            }
            
            
            
            addButtonView
        }
    }
    
    private var categoriesView: some View {
        VStack {
            DropDownBar(isDropDownActive: $isCountryDropDownActive, title: "choose_car_category".localized)
                .onTapGesture {
                    isCountryDropDownActive.toggle()
                }
            if isCountryDropDownActive {
                VStack(alignment: .leading){
                    ForEach(viewModel.getCarCategory,id: \.id) { item in
                        HStack{
                            SpareCityFilterBox(isBoxActive: item.id == (viewModel.carCategorySelected?.id ?? 0), city: item.name ?? "")
                                .onTapGesture {
                                    viewModel.carCategorySelected = item
                                    viewModel.carModel?.setCategory(category: item)
                                    viewModel.getBrand(categoryId: "\(item.id ?? 0)")
                                }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private var carBrandView: some View {
        VStack {
            DropDownBar(isDropDownActive: $isCityDropDownActive, title: "choose_car_brand".localized)
                .onTapGesture {
                    isCityDropDownActive.toggle()
                }
            
            if isCityDropDownActive {
                VStack(alignment: .leading){
                    ForEach(viewModel.getCarBrand,id: \.id) { item in
                        HStack{
                            SpareCityFilterBox(isBoxActive: item.id == (viewModel.carBrandSelected?.id ?? 0), city: item.name ?? "")
                                .onTapGesture {
                                    viewModel.carBrandSelected = item
                                    viewModel.carModel?.setBrand(brand: item)
                                    viewModel.getModel(brandId: "\(item.id ?? 0)")
                                }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private var carModelView: some View {
        VStack {
            DropDownBar(isDropDownActive: $isRegionDropDownActive, title: "chose_car_model".localized)
                .onTapGesture {
                    isRegionDropDownActive.toggle()
                }
            
            if isRegionDropDownActive {
                VStack(alignment: .leading){
                    ForEach(viewModel.getCarModel,id: \.id) { item in
                        HStack{
                            SpareCityFilterBox(isBoxActive: item.id == (viewModel.carModelSelected?.id ?? 0), city: item.name ?? "")
                                .onTapGesture {
                                    viewModel.carModelSelected = item
                                    viewModel.carModel?.setModel(model: item)
                                    viewModel.getYears(modelId: "\(item.id ?? 0)")
                                }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private var yearsView: some View {
        VStack {
            DropDownBar(isDropDownActive: $isdateDropDownActive, title: "chose_manufacture_date".localized)
                .onTapGesture {
                    isdateDropDownActive.toggle()
                }
            
            if isdateDropDownActive {
                VStack(alignment: .leading){
                    ForEach(viewModel.getCarYears, id: \.self) { item in
                        HStack{
                            SpareCityFilterBox(isBoxActive: "\(item)" == (viewModel.carYearSelected ?? "0"), city: "\(item)")
                                .onTapGesture {
                                    viewModel.carYearSelected = "\(item)"
                                    viewModel.carModel?.setYear(year: item)
                                }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private var chestView: some View {
        VStack {
            TitleLabel(title: "enter_chest_number".localized)
                .padding(.horizontal)
            HStack{
                PlainUIKitTextField(
                    text: $fieldText,
                    placeholder: ""
                )
                .frame(height: 38)
            }
            .padding(.horizontal,10)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.CWhite)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.MainColor, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
            .padding(1)
            .padding(.horizontal)
        }
    }
   
    
    private var addButtonView: some View {
        HStack{
            SimpleSpareButton(buttonTitle: "add", action: {
                if isValid() {
                    viewModel.AddCarData(paramter: .init(car_category_id: "\(viewModel.carCategorySelected?.id ?? 0)",car_brand_id: "\(viewModel.carBrandSelected?.id ?? 0)",car_model_id: "\(viewModel.carModelSelected?.id ?? 0)", year: viewModel.carYearSelected ?? "", chassis_number: fieldText, is_default: "1"))
                }
               
                
            }, widthValue: 300, heightValue: 45)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    func isValid() -> Bool {
        var isValid = true
        if viewModel.carCategorySelected?.id == nil  {
            is_category_validation_label = false
            isValid = false
        }else{
            is_category_validation_label = true
        }
        if viewModel.carBrandSelected?.id == nil {
            is_brand_validation_label = false
            
            isValid = false
        }else{
            is_brand_validation_label = true
        }
        
        if viewModel.carModelSelected?.id == nil {
            is_model_validation_label = false
            
            isValid = false
        }else{
            is_model_validation_label = true
        }
        
        if  viewModel.carYearSelected == nil  {
            is_year_validation_label = false
            
            isValid = false
        }else{
            is_year_validation_label = true
        }
        
        if fieldText.count == 0  {
            is_chest_validation_label = false
            
            isValid = false
        }else{
            is_chest_validation_label = true
        }
        
        return isValid
    }
    
    
    private func validationLabel(label: String) -> some View {
      return  HStack{
            Text(label)
                .font(addFont(fontType: .bold, size: 12))
                .foregroundStyle(Color.CRed)
            
            Spacer()
      }.padding(.horizontal,16)
    }
}



