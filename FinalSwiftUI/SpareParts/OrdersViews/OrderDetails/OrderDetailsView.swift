//
//  OrderDetailsView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//

import SwiftUI

struct OrderDetailsView: View {
    @ObservedObject var viewModel: OrderDetailsViewModel
    @State private var showSheet = false
    @State private var bottomSheetType: BottomSheetType = .cancel
    @State private var showImages = false
    
    init(viewModel: OrderDetailsViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        mainContent
            .onChange(of: showSheet) { newValue in
                if newValue == false {
                    viewModel.getOrderData(orderId: viewModel.orderId)
                }
            }
            
            .overlay {
                GenaricOrderBottomSheet(reasons: viewModel.problemTypes , isPresented: $showSheet, orderId: viewModel.orderId, type: bottomSheetType)
            }
            
            
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerView
            ShowViewState(state: viewModel.state) { Model in
                if let model = Model {
                    getClientScrollView(data: model)
                        .overlay {
                            let allImages = model.items?.compactMap { $0.images }.flatMap { $0 } ?? []
                            OfferImagesViewPopup(isPresented: $showImages, images: allImages)
                        }
                }
            }
            .ignoresSafeArea()
            .padding(.top)
           
            
            Spacer()
        }.background(
            Color(Color.backGroundColor)
        )
    }
    
    private var headerView: some View {
        AppHeaderView(Title: "order details".localized) {
            viewModel.coordinator.disMiss()
        }
    }
    

    private func getClientScrollView(data: OrderDetailsModel) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                OrderInfoSection(data: data, onChat: {
                    viewModel.openChat(with: data, title: "\(data.trader?.tradeName ?? "")-\(data.orderNumber ?? "")")
                })
                if data.address != nil {
                    TitleLabel(title: "address details".localized)
                        .padding(.horizontal)
                    AddressSection(data: data)
                }
                TitleLabel(title: "car details".localized)
                    .padding(.horizontal)
                CarDetailsSection(data: data)
                TitleLabel(title: "ordered parts menu".localized)
                    .padding(.horizontal)
                OrderedPartsSection(data: data, showImages: $showImages)
                TitleLabel(title: "offers menu".localized)
                    .padding(.horizontal)
                OffersSection(data: data) { offer in
                    viewModel.coordinator.showOfferDetails(offerId: "\(offer.id ?? 0)", orderId: "\(data.id ?? 0)", OfferModel: offer )
                }
                
                if data.canPay == true || localizedPaymentMethod(data.paymentMethod ?? "") != "--" {
                    TitleLabel(title: "payment details".localized)
                        .foregroundStyle(Color.SecondaryColor)
                        .padding(.horizontal)
                    PaymentDetailsSection(data: data, paymentMethod: localizedPaymentMethod(data.paymentMethod ?? ""))
                }

                if let myOffer = data.myOffer {
                    TitleLabel(title: "Offer Details".localized)
                        .foregroundStyle(Color.SecondaryColor)
                        .padding(.horizontal)
                    MyOfferSection(offer: myOffer, isPickup: isPickup(data: data), isShowOfferButton: data.myOffer?.can_update ?? false) {
                        viewModel.coordinator.sendOfferView(
                            orderModel: data,
                            ItemsModel: itemsPrefilledWithMyOffer(data: data)
                        )
                    }
                }

                getButtens(data: data)
                    .padding(.top)

                if let ratingDetails = data.ratingDetails {
                    TitleLabel(title: "rating details".localized)
                        .padding(.horizontal)
                    RatingDetailsSection(rating: ratingDetails)
                }

                if localizedPaymentMethod(data.paymentMethod ?? "") != "--" {
                    ProblemDetails(data: data, paymentMethod: localizedPaymentMethod(data.paymentMethod ?? ""))
                        .padding(.horizontal)
                }
            }
        }.refreshable {
            viewModel.getOrderData(orderId: viewModel.orderId)
        }
    }
    /// الطلب استلام من المحل -> مفيش سعر شحن
    private func isPickup(data: OrderDetailsModel) -> Bool {
        (data.deliveryType?.value ?? "").lowercased() == "pickup"
    }

    /// نجهز القطع بأسعار العرض المرسل عشان شاشة التعديل تفتح بالقيم القديمة
    private func itemsPrefilledWithMyOffer(data: OrderDetailsModel) -> [DataItem] {
        var result = data.items ?? []
        guard let offerItems = data.myOffer?.items else { return result }

        for index in result.indices {
            if let matched = offerItems.first(where: { $0.orderItem?.id == result[index].id }) {
                result[index].partPrice = matched.price.map { String(format: "%g", $0) } ?? ""
                result[index].isAvailable = matched.isAvailable ?? true
            }
        }
        return result
    }

    func localizedPaymentMethod(_ method: String?) -> String {

        let value = method?

            .lowercased()

            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if value.isEmpty {

            return "--"

        } else if value.contains("wallet") {

            return  "Wallet".localized

        } else {

            return "Visa".localized

        }
    }
    @ViewBuilder
    private func getButtens(data: OrderDetailsModel) -> some View {
        VStack {
 
            if isClient == false {
                if data.can_send_offer == true {
                    sendPriceButton
                }
               
                
              
             
              
                         
                if data.status?.value == "PAID".lowercased() {
                    shippingButton(status: "PROCESSING".lowercased(), name: "On Progress".localized)
                }
                
                if data.status?.value == "PROCESSING".lowercased() {
                    shippingButton(status: "READY".lowercased(), name: "Running".localized)
                }
                
                if data.status?.value == "READY".lowercased() {
                    shippingButton(status: "SHIPPING".lowercased(), name: "Shipping".localized)
                }
                
                if data.status?.value == "SHIPPING".lowercased() {
                    shippingButton(status: "WAITING_RECEIPT".lowercased(), name: "Waiting for receipt".localized)
                }
                
                if data.can_download == true {
                    downloadBillButton
                }
                
                if data.canReport == true {
                    reportRedButton
                }

            }
          
        }
    }
    private var cancelButton: some View {
        SimpleSpareButton(
            buttonTitle: "Cancel order".localized,
            action: {
                print("cancel_order tapped")
                bottomSheetType = .cancel
                showSheet = true
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    
    private var paymentButton: some View {
        SimpleSpareButton(
            buttonTitle: "Payment".localized,
            action: {
                viewModel.coordinator.showGatWay(orderId: viewModel.orderId)
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    private var confirmReceiptButton: some View {
        WhiteSpareButton(
            buttonTitle: "Confirm receipt".localized,
            action: {
                viewModel.recept(orderId: viewModel.orderId)
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    private var reportButton: some View {
        WhiteSpareButton(
            buttonTitle: "Report a problem".localized,
            action: {
                print("Report a problem tapped")
                bottomSheetType = .reportProblem
                showSheet = true
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    private var rateButton: some View {
        SimpleSpareButton(
            buttonTitle: "Rate".localized,
            action: {
                print("Rate tapped")
                bottomSheetType = .rate
                showSheet = true
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    private var downloadBillButton: some View {
        SimpleSpareButton(
            buttonTitle: "Download bill".localized,
            action: {
                if let url = URL(string: "\(hostName)general/orders/\(viewModel.orderId)/invoice") {
                               UIApplication.shared.open(url)
                           }
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    private var sendPriceButton: some View {
        SimpleSpareButton(
            buttonTitle: "Send price offer".localized,
            action: {
                if let data = viewModel.state.data {
                    viewModel.coordinator.sendOfferView(orderModel: data, ItemsModel: itemsPrefilledWithMyOffer(data: data))
                }
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    private func shippingButton(status: String, name: String)-> some View {
        WhiteSpareButton(
            buttonTitle: name,
            action: {
                print("Shipping tapped")
                viewModel.updateStatus(urlEndPoint: "\(status)")
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    private var shippingDoneButton: some View {
        SimpleSpareButton(
            buttonTitle: "Shipping done".localized,
            action: {
                print("Shipping done tapped")
                viewModel.updateStatus(urlEndPoint: "shipped")
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    private var waitingForReceiptButton: some View {
        WhiteSpareButton(
            buttonTitle: "Waiting for receipt".localized,
            action: {
                print("Waiting for receipt tapped")
                viewModel.updateStatus(urlEndPoint: "waiting_receipt")
            },
            widthValue: 300,
            heightValue: 50
        )
    }
    private var reportRedButton: some View {
        Button {
            bottomSheetType = .reportProblem
            showSheet = true
        } label: {
            Text("Report a problem".localized)
                .foregroundStyle(Color.CWhite)
                .frame(width: 300, height: 50)
                .background(
                    Color.CRed
                        .cornerRadius(20)
                )
        }
    }
}




struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(icon)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.SecondaryColor)
            
            Text(text)
                .foregroundStyle(Color.CGray1)
                .font(addFont(fontType: .Medium, size: 18))
        }
    }
}

struct OrderInfoSection: View {
    let data: OrderDetailsModel?
    var onChat: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                // First Column Items
                VStack(alignment: .leading, spacing: 14) {
                    if let orderNumber = data?.orderNumber {
                        InfoRow(icon: "number", text: orderNumber)
                    }
                    if let countries = data?.countries, countries.count > 0 {
                        InfoRow(icon: "city", text: countries.map { $0.name ?? "" }.joined(separator: ", "))
                    }
                    if data?.trader != nil {
                        InfoRow(icon: "name", text: data?.trader?.tradeName ?? "")
                    }
                    if let status = data?.status?.label {
                        InfoRow(icon: "time", text: status)
                    }
                    if let clientName = data?.client?.name, clientName.isEmpty == false {
                        InfoRow(icon: "name", text: clientName)
                    }
                }

                Spacer(minLength: 16)

                // Second Column Items
                VStack(alignment: .leading, spacing: 14) {
                    if let cities = data?.cities, cities.count > 0 {
                        InfoRow(icon: "Country", text: cities.map { $0.name ?? "" }.joined(separator: ", "))
                    }
                    if let orderType = data?.orderType?.label {
                        InfoRow(icon: "local_shipping_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24", text: orderType)
                    }
                    if let createdAt = data?.createdAt {
                        InfoRow(icon: "calendar_clock_-1", text: createdAt)
                    }
                    if let itemCount = data?.items?.count {
                        InfoRow(icon: "car", text: "\(itemCount)")
                    }
                    if let deliveryType = data?.deliveryType?.label {
                        InfoRow(icon: "shipping", text: deliveryType)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.CWhite)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
            .padding(.horizontal)

            // نظهر الزرار طول ما فيه عميل مربوط بالطلب
            if data?.can_chat == true
               && data?.hasChat == true
                {
                Button {
                    onChat?()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "ellipsis.message.fill")
                            .font(.system(size: 22))
                        Text("Contact Client".localized)

                    }
                    .foregroundStyle(Color.CWhite)
                    .frame(width: 300, height: 50)
                    .background(
                        Color.MainColor
                            .cornerRadius(20)
                    )
                }
            }
        }
    }
}

struct AddressSection: View {
    let data: OrderDetailsModel?

    private var descriptionText: String {
        let desc = data?.address?.description?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return desc.isEmpty ? "no additional address description".localized : desc
    }

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 0) {
                HStack {
                    Image("location-1")
                        .resizable()
                        .foregroundStyle(Color.SecondaryColor)
                        .frame(width: 24, height: 24)

                    Spacer()

                    Text(data?.address?.addressText ?? "")
                        .frame(width: 200, alignment: .trailing)
                }
                .padding()

                if let lat = data?.address?.latitude, let lng = data?.address?.longitude {
                    Divider()

                    Button {
                        openLocationOnMap(lat: lat, lng: lng)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "map.fill")
                                .font(.system(size: 16))
                            Text("merchant.show_map".localized)
                                .font(addFont(fontType: .bold, size: 14))
                            Spacer()
                        }
                        .foregroundStyle(Color.MainColor)
                        .padding()
                    }
                }

                Divider()

                HStack {
                    Spacer()
                    Text("address more details".localized)
                        .foregroundStyle(Color.MainColor)
                        .font(addFont(fontType: .bold, size: 14))
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.CWhite)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)

            Text(descriptionText)
                .foregroundStyle(Color.CGray1)
                .font(addFont(fontType: .Medium, size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }

    private func openLocationOnMap(lat: Double, lng: Double) {
        let urlString = "comgooglemaps://?q=\(lat),\(lng)&zoom=14"
        if let url = URL(string: urlString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let webURL = URL(string: "https://maps.google.com/?q=\(lat),\(lng)") {
            UIApplication.shared.open(webURL)
        }
    }
}

struct MyOfferSection: View {
    let offer: Offer
    var isPickup: Bool = false
    var isShowOfferButton: Bool
    var onUpdate: () -> Void
   

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 14) {
                PaymentRow(
                    title: "Total price".localized,
                    value: "\(offer.subtotal ?? 0) " + "R.S".localized
                )

                PaymentRow(
                    title: "Value Added Tax".localized,
                    value: "\(offer.taxAmount ?? 0) " + "R.S".localized
                )

                if !isPickup {
                    PaymentRow(
                        title: "Shipping cost".localized,
                        value: "\(offer.shippingCost ?? 0) " + "R.S".localized
                    )
                }

                Divider()

                HStack(alignment: .top) {
                    Text("Total price offer".localized)
                        .foregroundStyle(Color.MainColor)
                        .font(addFont(fontType: .bold, size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("\(offer.totalAmount ?? 0) " + "R.S".localized)
                        .foregroundStyle(Color.MainColor)
                        .font(addFont(fontType: .bold, size: 15))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                if let status = offer.status?.label {
                    Divider()
                    PaymentRow(title: "Order Status".localized, value: status)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.CWhite)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
            if isShowOfferButton {
                Button {
                    onUpdate()
                } label: {
                    Text("Update offer".localized)
                        .font(addFont(fontType: .bold, size: 15))
                        .foregroundStyle(Color.MainColor)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.MainColor, lineWidth: 1)
                        )
                }
            }
           
        }
        .padding(.horizontal)
    }
}

struct RatingDetailsSection: View {
    let rating: OrderRating

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: Double(index) <= (rating.rating ?? 0) ? "star.fill" : "star")
                        .font(.system(size: 22))
                        .foregroundColor(Double(index) <= (rating.rating ?? 0) ? .yellow : Color.CGray2)
                }
                Spacer()
                if let createdAt = rating.createdAt {
                    Text(createdAt)
                        .foregroundStyle(Color.CGray1)
                        .font(addFont(fontType: .Regular, size: 14))
                }
            }

            if let comment = rating.comment?.trimmingCharacters(in: .whitespacesAndNewlines),
               comment.isEmpty == false {
                Text(comment)
                    .foregroundStyle(Color.CGray1)
                    .font(addFont(fontType: .Medium, size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        .padding(.horizontal)
    }
}

struct CarDetailsSection: View {
    let data: OrderDetailsModel?
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 14) {
                InfoRow(icon: "car-1", text: data?.vehicle?.category ?? "")
                InfoRow(icon: "Car type", text: data?.vehicle?.brand ?? "")
                InfoRow(icon: "Car model", text: data?.vehicle?.chassisNumber ?? "")
            }

            Spacer()

            VStack(alignment: .leading, spacing: 14) {
                InfoRow(icon: "cars", text: data?.vehicle?.model ?? "")
                InfoRow(icon: "date", text: String(data?.vehicle?.year ?? 2020))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        .padding(.horizontal)
    }
}

struct OrderedPartsSection: View {
    let data: OrderDetailsModel?
    @Binding var showImages: Bool
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(data?.items ?? [], id: \.id) { item in
                OrderedPartCard(
                    part: .init(
                        name: item.partName ?? "",
                        number: item.partNumber ?? "",
                        count: String(item.quantity ?? 0),
                        type: item.partType?.label ?? "",
                        notes: item.description
                    ),
                    id: item.id ?? 0
                ) {
                    print("show pictures tapped")
                    showImages = true

                }
            }
        }
        .padding(.horizontal)
    }
}

struct OffersSection: View {
    let data: OrderDetailsModel?
    var offerAction: ((Offer) -> Void)?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(data?.offers ?? [], id: \.id) { offer in
                    OffersCardView(canMessage: data?.hasChat ?? false ,part: OffersCardModel(name: offer.trader?.tradeName ?? "", country: "saudia", city: "ryiadh", price: String(offer.totalAmount ?? 0)), buttonTitle: "show offer details".localized) {
                        offerAction?(offer)
                    } onMessage: {
                        print("Message tapped...")
                    }
                }
            }
            .padding(.leading)
        }
    }
}

struct PaymentDetailsSection: View {
    let data: OrderDetailsModel?
    var paymentMethod: String = "-"
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    InfoRow(icon: "number", text: data?.orderNumber ?? "")
                    InfoRow(icon: "mouny", text: "\(data?.totalAmount ?? 0) " + "R.S".localized)
                }

                Spacer(minLength: 40)

                VStack(alignment: .leading, spacing: 10) {
                    InfoRow(icon: "wallet", text: paymentMethod)
                    InfoRow(icon: "calendar_clock_-1", text: data?.createdAt ?? "")
                        .minimumScaleFactor(0.6)
                }
                .padding(.trailing)
            }
            Button {
                print("show payment details")
            } label: {
                Image(systemName: "arrow.down.to.line")
                    .foregroundStyle(Color.MainColor)
                    .font(.system(size: 25))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        .padding(.horizontal)
    }
}

struct PaymentDetailsInfoView: View {
    let data: OrderDetailsModel?
    
    var body: some View {
        VStack(spacing: 18) {
            
            PaymentRow(
                title: "Date and Time".localized,
                value: data?.createdAt ?? "-"
            )
            
            PaymentRow(
                title: "Used Payment Methods".localized,
                value: data?.walletUsed == 1 ? "المحفظة" : "-"
            )
            
            PaymentRow(
                title: "Used Wallet Balance".localized,
                value: "\(data?.walletUsed ?? 0) " + "R.S".localized
            )
            
            PaymentRow(
                title: "Payment Method Name".localized,
                value: data?.paymentMethod ?? "-"
            )
            
            PaymentRow(
                title: "Paid Amount".localized,
                value: "\(data?.totalAmount ?? 0) " + "R.S".localized
            )
            
            PaymentRow(
                title: "Transaction Reference Number".localized,
                value: String(data?.id ?? 0)
            )
        }
        .padding(.horizontal)
    }
}


struct PaymentRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundStyle(Color.SecondaryColor)
                .font(addFont(fontType: .bold, size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(value)
                .foregroundStyle(Color.SecondaryColor)
                .font(addFont(fontType: .Regular, size: 14))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct ProblemDetails: View {
    let data: OrderDetailsModel?
    let paymentMethod: String
    var body: some View {
        VStack(spacing: 18) {

            PaymentRow(
                title: "Date and Time".localized,
                value: data?.createdAt ?? "-"
            )

            PaymentRow(
                title: "Used Payment Methods".localized,
                value: paymentMethod
            )
        }
    }
}
