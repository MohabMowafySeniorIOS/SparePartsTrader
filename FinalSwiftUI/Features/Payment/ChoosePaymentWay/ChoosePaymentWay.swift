//
//  ChoosePaymentWay.swift
//  SpareParts
//
//  Created by Mohab on 25/02/2026.
//

import SwiftUI

struct PaymentMethodsView: View {

    @ObservedObject var vm: PaymentVM
    init(vm: PaymentVM) {
        self._vm = ObservedObject(wrappedValue: vm)
    }

    var body: some View {
        VStack(spacing: 20) {
            AppHeaderView(Title: "Choose Payment Method".localized) {
                vm.disMiss()
            }
            
            ShowViewState(state: vm.state) { Model in
                scrollView
            }
            Spacer()
            paymnetButton
           

        }
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 12) {

                ForEach(vm.gateways) { gateway in
                    GatewayRow(
                        gateway: gateway,
                        isSelected: vm.selectedGateway?.id == gateway.id
                    ) {
                        vm.selectedGateway = gateway
                        vm.selectedBrand = nil
                    }

                    // Show brands if needed
                    if vm.selectedGateway?.id == gateway.id,
                       gateway.requiresBrand {

                        BrandListView(
                            brands: gateway.brands,
                            selectedBrand: vm.selectedBrand
                        ) { brand in
                            vm.selectedBrand = brand
                        }
                        .padding(.leading, 20)
                    }
                }
            }
            .padding()
        }
    }
    
    private var paymnetButton: some View {
        
        Button("Continue") {
            vm.checkOut(paramter: .init(payment_method: vm.selectedGateway?.id ?? "", brand: "\(vm.selectedBrand?.id ?? "")"))
        }
        .buttonStyle(.borderedProminent)
        .disabled(!vm.canContinue)
    }
}
struct GatewayRow: View {

    let gateway: Gateway
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {

                AsyncImage(url: URL(string: gateway.icon ?? "")) { img in
                    img.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 40, height: 40)
                .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(gateway.label).bold()
                    Text(gateway.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3)))
        }
    }
}
struct BrandListView: View {

    let brands: [BrandGateway]
    let selectedBrand: BrandGateway?
    let onSelect: (BrandGateway) -> Void

    var body: some View {
        VStack(spacing: 8) {

            ForEach(brands, id: \.id) { brand in
                Button {
                    onSelect(brand)
                } label: {
                    HStack {

                        AsyncImage(url: URL(string: brand.icon ?? "")) { img in
                            img.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 30, height: 30)

                        Text(brand.name ?? "")

                        Spacer()

                        if selectedBrand?.id == brand.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.08))
                    )
                }
            }
        }
    }
}
