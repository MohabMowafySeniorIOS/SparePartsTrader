//
//  AddressAgendaView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 20/07/2025.
//

import SwiftUI

struct AddressAgendaView: View {
    
    @ObservedObject private var viewModel: AddressAgendaViewModel
    init(viewModel: AddressAgendaViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        mainContent
            .background(
                Color(Color.backGroundColor)
            )
    }
    
    private var mainContent: some View {
        VStack {
            appHeader
            addAddressButton
            ShowViewState(state: viewModel.state) { Model in
                addressView
            }
            Spacer()
        }
        
    }
  
    
  
    
    private var appHeader: some View {
        AppHeaderView(Title: "address_agenda".localized) {
            viewModel.disMiss()
        }
    }
    
    private var addAddressButton: some View {
        SimpleSpareButton(buttonTitle: "add_address".localized, action: {
            viewModel.coordinator.showAddAddresses(addressModel: nil)
        }, widthValue: 300, heightValue: 50)
        .padding()
    }
    
    private var addressView: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(spacing:20) {
                TitleLabel(title: "added_addresses_menu".localized)
                
                addressListView
                
            }
        }
        .padding(.horizontal)
    }
    
    private var addressListView: some View {
        ForEach(viewModel.myAddresses,id: \.id) { item in
            addressCardView(item: item)
        }
    }

    private func addressCardView(item: AddressData) -> some View {
        VStack(spacing: 14) {
            HStack {
                Text("address".localized)
                    .font(addFont(fontType: .bold, size: 15))
                    .foregroundStyle(Color.SecondaryColor)
                Spacer()
                Text(item.address_text ?? "")
                    .font(addFont(fontType: .Regular, size: 15))
                    .foregroundStyle(Color.CGray2)
            }

            Divider()

            HStack(spacing: 12) {
                SimpleSpareButton(buttonTitle: "Edit".localized, action: {
                    viewModel.coordinator.showAddAddresses(addressModel: item)
                }, widthValue: .infinity, heightValue: 44)

                SmallButtonWithBorder(action: {
                    viewModel.deleteAddressAgenda(id: "\(item.id ?? 0)")
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
}

