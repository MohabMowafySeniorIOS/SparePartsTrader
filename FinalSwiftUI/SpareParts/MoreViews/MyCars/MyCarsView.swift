//
//  MyCarsView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 20/07/2025.
//

import SwiftUI

struct MyCarsView: View {
    @ObservedObject private var viewModel: MyCarsViewModel
    init(viewModel: MyCarsViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    @State private var rotation: Double = 0
    @State private var isLoading = true
    
    var body: some View {
        mainContent
            .background(
                Color(Color.backGroundColor)
            )
        
    }
    
    private var mainContent: some View {
        VStack {
            appHeader
            addCarButton
            ShowViewState(state: viewModel.state) { Model in
                carView
            }
            Spacer()
        }
        
    }
   
    private var appHeader: some View {
        AppHeaderView(Title: "menu_myCars".localized) {
            viewModel.disMiss()
        }
    }
    
    private var addCarButton: some View {
        SimpleSpareButton(buttonTitle: "add_car".localized, action: {
            viewModel.coordinator.showAddCars(carId: nil)
        }, widthValue: 300, heightValue: 50)
        .padding()
    }
    
    private var carView: some View {
        
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(spacing:20) {
                TitleLabel(title: "added_cars_menu")

                ForEach(viewModel.myCars , id: \.id) { item in
                    AddCarCard(Model: item,selectEdit: {
                        viewModel.coordinator.showAddCars(carId: item)
                    }, selectDelete: {
                        viewModel.deleteCars(car_id: "\(item.id ?? 0)")
                    })
                    
                }
            }
        }
        .padding(.horizontal)
        
    }
}





struct AddCarCard: View {
    var Model: CarsData
    var selectEdit: () -> Void
    var selectDelete: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            carRow(label: "category".localized, value: Model.category?.name ?? "")
            carRow(label: "brand".localized, value: Model.brand?.name ?? "")
            carRow(label: "model".localized, value: Model.model?.name ?? "")
            carRow(label: "manufacture_year".localized, value: "\(Model.year ?? 0)")
            carRow(label: "chest_number".localized, value: Model.chassis_number ?? "")

            Divider()

            HStack(spacing: 12) {
                SimpleSpareButton(buttonTitle: "Edit".localized, action: {
                    selectEdit()
                }, widthValue: .infinity, heightValue: 44)

                SmallButtonWithBorder(action: {
                    selectDelete()
                }, title: "Delete".localized)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    private func carRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(addFont(fontType: .bold, size: 15))
                .foregroundStyle(Color.SecondaryColor)
            Spacer()
            Text(value)
                .font(addFont(fontType: .Regular, size: 15))
                .foregroundStyle(Color.CGray2)
        }
    }
}
