//
//  SendOfferView.swift
//  SpareParts
//
//  Created by Mohab on 04/03/2026.
//

import Foundation
import SwiftUI
struct PartItem: Identifiable {
    
    let id = UUID()
    
    var name: String
    var type: String
    var quantity: Int
    
    var price: String = ""
    var shipping: String = ""
}

struct SendOfferView: View {
    @State var is_charge_validation_label: Bool = true
    @State var is_parts_validation_label: Bool = true
    @State var items: [DataItem]
    @State private var chargePriceInput = ""
    var totalPrice: Double {
        items.reduce(0) { result, item in
            let price = Double(item.partPrice) ?? 0
            let quantity = Double(item.quantity ?? 0)
            return result + (price * quantity)
        }
    }
    
    var vatPrice: Double {
        
        return totalPrice * (viewModel.orderModel?.vat ?? 15)/100
    }
    
    var totalPriceWithVat: Double {
        
        return vatPrice + totalPrice
    }
    
    var totalOfferPrice: Double {
        
        return (Double(chargePriceInput) ?? 0.0) + totalPriceWithVat
    }
    
    var totalPlatformCommissionPrice: Double {
        
        return totalOfferPrice * (viewModel.orderModel?.platform_commision ?? 15)/100
    }
    
    
    var totalSummaryPrice: Double {
        
        return totalOfferPrice - totalPlatformCommissionPrice
    }
   
    
    
    @ObservedObject var viewModel: SendOfferViewModel
    init(viewModel: SendOfferViewModel,items: [DataItem]) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.items = items
        // لو فيه عرض مرسل قبل كده نجيب سعر الشحن بتاعه عشان التعديل
        let previousShipping = viewModel.orderModel?.myOffer?.shippingCost
        self._chargePriceInput = State(initialValue: previousShipping.map { String(format: "%g", $0) } ?? "")
    }

    /// الطلب استلام من المحل -> مفيش شحن
    private var isPickup: Bool {
        (viewModel.orderModel?.deliveryType?.value ?? "").lowercased() == "pickup"
    }

    /// التاجر باعت عرض قبل كده -> الشاشة بقت تعديل عرض
    private var isUpdatingOffer: Bool {
        viewModel.orderModel?.myOffer != nil
    }

    private var screenTitle: String {
        isUpdatingOffer ? "Update offer".localized : "Send a price quote".localized
    }
    
    var body: some View {
        VStack() {
            
            AppHeaderView(Title: screenTitle) {
                viewModel.disMiss()
            }
            
            mainContent
          Spacer()
        }.background(
            Color(Color.backGroundColor)
        )
    }
    
    
    private var mainContent: some View {
        ShowViewState(state: viewModel.state) { Model in
            VStack {
                scrollView
                 Spacer()
                 sendButton
            }
        }
    }
    
    private var scrollView: some View {
        ScrollView(showsIndicators: false) {
            
            VStack {
                
                ForEach($items,id: \.id) { $part in
                    PartCardView(part: $part)
                        .padding(.horizontal)
                        .padding(.top)
                }
                
                if !isPickup {
                    VStack(alignment:.trailing) {
                        HStack {
                            Text("Charge Price".localized)
                            Spacer()
                        }
                        VStack(spacing: 2) {
                            PlainUIKitTextField(
                                text: $chargePriceInput,
                                placeholder: "",
                                keyboardType: .numberPad,
                                isNumeric: true
                            )
                                .frame(height: 24)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4))
                                )
                            if !is_charge_validation_label {
                                validationLabel(label: "validation_required".localized)
                            }
                        }

                    }.padding(.horizontal)
                }
            }
            
            offerDetails
                .padding(.horizontal)
        }
    }
    
    private func validationLabel(label: String) -> some View {
      return  HStack{
            Text(label)
                .font(addFont(fontType: .bold, size: 12))
                .foregroundStyle(Color.CRed)
            
            Spacer()
        }
    }
    
    private var sendButton: some View {
        ContentButtonView(title: screenTitle) {
            if isValid() {
                
                var partsParam: [offerParts] = []
                
                for item in items {
                    partsParam.append(offerParts(order_item_id: "\(item.id ?? 0)", price: item.partPrice, is_available: "\(item.isAvailable)"))
                }
              
                    viewModel.sendOffer(parts: partsParam, shipping_cost: isPickup ? "0" : chargePriceInput, orderId: "\(viewModel.orderModel?.id ?? 0)", offerId: "\(viewModel.orderModel?.myOffer?.id ?? 0)")
                
               
            }
        }
        .padding(.horizontal)
        .padding(.horizontal)
    }
    
    func isValid() -> Bool {
        var isValid = true
        
        if isPickup {
            // استلام من المحل: مفيش سعر شحن أصلاً
            is_charge_validation_label = true
        } else if chargePriceInput.count == 0 {
            is_charge_validation_label = false
            isValid = false
        } else {
            is_charge_validation_label = true
        }
        
        for index in items.indices {
            if self.items[index].partPrice == "" {
                isValid = false
                items[index].toggleisValid(value: false)
            }else {
                items[index].toggleisValid(value: true)
            }
            
        }
        
        return isValid
    }
}


struct CalcOfferDetails {
    
    var totalPrice = "-"
    var vat = "-"
    var total_price_by_vat = "-"
    var chargePrice = "-"
    var totalOfferPrice = "-"
    var platformCommission = "-"
    var deservedValue = "-"
    
}


extension SendOfferView {
   
    var offerDetails: some View {
        
        VStack(alignment: .trailing, spacing: 16) {
            HStack {
                Text("Offer Details".localized)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            
            detailRow(title: "Total price".localized, value: "\(totalPrice) " + "R.S".localized)
            detailRow(title: "Value Added Tax" .localized, value: "\(vatPrice) " + "R.S".localized)
            detailRow(title: "Total price including tax".localized, value: "\(totalPriceWithVat) " + "R.S".localized)
            if !isPickup {
                detailRow(title: "Shipping cost".localized, value: "\(chargePriceInput) " + "R.S".localized)
            }
            detailRow(title: "Total price offer".localized , value: "\(totalOfferPrice) " + "R.S".localized)
            detailRow(title: "Total platform commission".localized , value: "\(totalPlatformCommissionPrice) " + "R.S".localized)
            detailRow(title: "Amount Due".localized, value: "\(totalSummaryPrice) " + "R.S".localized)
            
        }
        .padding(.top)
    }
    
    func detailRow(title: String, value: String) -> some View {
        
        HStack {
            Text(title)
            
            
            Spacer()
            Text(value)
                .fontWeight(.semibold)
            
        }
    }
}


struct PartCardView: View {
  
    @Binding var part: DataItem
    @State private var piecePriceInput = ""

    var body: some View {
        
        VStack(alignment:.trailing, spacing:16) {
            
            // توفر / عدم توفر القطعة
            toggleSection

            Divider()

            // تفاصيل القطعة
            VStack(alignment: .leading, spacing: 10) {

                partRow(label: "part name".localized, value: part.partName ?? "-")
                partRow(label: "part number".localized, value: part.partNumber ?? "-")
                partRow(label: "parts count".localized, value: "\(part.quantity ?? 0)")
                partRow(label: "part type".localized, value: part.partType?.label ?? "-")

                if let notes = part.description?.trimmingCharacters(in: .whitespacesAndNewlines),
                   notes.isEmpty == false {

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("part notes".localized)
                                .foregroundStyle(Color.SecondaryColor)
                                .font(addFont(fontType: .Medium, size: 15))
                            Spacer()
                        }
                        HStack {
                            Text(notes)
                                .foregroundStyle(Color.CBlack)
                                .font(addFont(fontType: .Regular, size: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                }
            }

            Divider()
            
            // Inputs
            HStack(spacing:12) {
                
                VStack(alignment:.trailing) {
                   
                    HStack {
                        Text("Part Price".localized)
                        Spacer()
                    }
                   
                    VStack(spacing: 2) {
                        PlainUIKitTextField(
                            text: $part.partPrice,
                            placeholder: "",
                            keyboardType: .numberPad,
                            isNumeric: true
                        )
                            .frame(height: 24)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.4))
                            )
                        if !part.isValid {
                            validationLabel(label: "validation_required".localized)
                        }
                    }
                    
                }
                
               
            }
        }
        .padding()
        .background(Color(Color.backGroundColor))
        .clipShape(RoundedRectangle(cornerRadius:18))
        .shadow(color: .black.opacity(0.3), radius:6)
    }
    
    private func validationLabel(label: String) -> some View {
      return  HStack{
            Text(label)
                .font(addFont(fontType: .bold, size: 12))
                .foregroundStyle(Color.CRed)
            
            Spacer()
        }
    }
    
    private func partRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(Color.SecondaryColor)
                .font(addFont(fontType: .Medium, size: 15))
            Spacer()
            Text(value)
                .foregroundStyle(Color.CBlack)
                .font(addFont(fontType: .bold, size: 15))
                .multilineTextAlignment(.trailing)
        }
    }

    // MARK: Toggle Section
    private var toggleSection: some View {
        HStack {

            Text("part availability".localized)
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            
            Toggle("", isOn: $part.isAvailable)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.SecondaryColor))
        }
    }
}

struct CustomField: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius:10)
                    .stroke(Color.gray.opacity(0.4))
            )
    }
}
