//
//  MainAuthView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation
import Foundation
import SwiftUI
struct MainCoordinatorView: View {

    @StateObject private var coordinator: MainCoordinator

    init(appCoordinator: AppCoordinator) {
        _coordinator = StateObject(
            wrappedValue: MainCoordinator(appCoordinator: appCoordinator)
        )
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {

            MainTabView(coordinator: coordinator)
            .navigationDestination(for: MainRoute.self) { route in
                switch route {
                    
                case .MyCars:
                    MyCarsView(viewModel: MyCarsViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .addCar(let carModel):
                    AddCarView(viewModel: AddCarViewModel(coordinator: coordinator, carModel: carModel))
                        .navigationBarHidden(true)
                case .MyAddress:
                    AddressAgendaView(viewModel: AddressAgendaViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .AddAddress(let addressModel):
                    AdditionalAddressDescribtionView(viewModel: AdditionalAddressDescribtionViewModel(addressModel: addressModel, onDismiss: {
                        coordinator.path.removeLast()
                    }))
                        .navigationBarHidden(true)
                case .Wallet:
                    WalletMainView(viewModel: WalletViewModel(coordinator: coordinator), isShowBakButton: false)
                        .navigationBarHidden(true)
                case .FAQ:
                    FAQScreen(viewModel: FAQViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
               
                case .About_us(let Page):
                    TermsVC(pageTitle: Page , viewModel: TermsViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
               
                case .messages:
                    MessagesView(viewModel: MessagesViewModel(coordinator: coordinator))
                         .navigationBarHidden(true)
                case .chatView(let roomId,let title):
                    chatView(viewModel: ChatViewModel(coordinator: coordinator, roomId: roomId, title: title))
                         .navigationBarHidden(true)
                    
                case .settings:
                   SettingsView(coordinator: coordinator)
                        .navigationBarHidden(true)
                    
                case .Contact:
                    ContactUSView(viewModel: contactUsViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .Profile:
                    ProfileVC(viewModel: ProfileViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .createOrder(mainOrderType: let mainOrderType, let specificVendor):
                    
                    CreateOrderView(viewModel: CreateOrderViewModel(coordinator: coordinator,specificVendor: specificVendor),mainOrderType: mainOrderType)
                        .navigationBarHidden(true)
                case .vendorDetails(rating: let rating, vendorId: let vendorId):
                    VendorDetailsView(viewModel: VendorDetailsViewModel(coordinator: coordinator, vendorId: vendorId), rating: rating)
                        .navigationBarHidden(true)
                case .showNotification:
                    NotificationsView(viewModel: NotificationsViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .updatePassword:
                    UpdatePasswordView(viewModel: UpdatePasswordViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .OrderDetailsView(let orderId):
                    OrderDetailsView(viewModel: OrderDetailsViewModel(coordinator: coordinator, orderId: orderId))
                        .navigationBarHidden(true)
                    
                case .updatePhone:
                    UpdatePhoneView(viewModel: UpdatePhoneViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .updateOtp(let phone):
                    UpdateOTPView(phone: phone, viewModel: UpdateVerificationViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .WithDraw:
                    WithDrawView(viewModel: WithDrawViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                    
//                case .addPiece:
//                    AddPieceView(viewModel: AddPieceViewModel(coordinator: coordinator))
//                        .navigationBarHidden(true)
                case .offerDetails(offerId: let offerId, orderId: let orderId, let OfferModel):
                    OfferDetailsView(viewModel: OfferDetailsViewModel(coordinator: coordinator, offerId: offerId, orderId: orderId, OfferModel: OfferModel))
                        .navigationBarHidden(true)
                case .FileBusniss:
                    MerchantProfileView(viewModel: MerchantProfileViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .UpdateFileBusniss(userModel: let userModel):
                    AddMerchantView(viewModel: AddMerchantViewModel(onAddress: {
                        coordinator.showAddAddresses(addressModel: nil)
                    }, onDismiss: {
                        coordinator.path.removeLast()
                    }, onSuccess: {
                        print("onSuccess")
                    }), userModel: userModel)
                        .navigationBarHidden(true)
                    
                case .paymentScreen(url: let url):
                    PaymentScreen(viewModel: PaymentWebViewModel(coordinator: coordinator), url: url)
                        .navigationBarHidden(true)
                case .GatWay(orderId: let orderId):
                    PaymentMethodsView(vm: PaymentVM(coordinator: coordinator, orderId: orderId))                        .navigationBarHidden(true)
                case .SendOfferView(orderModel: let orderModel,ItemsModel: let items):
                    SendOfferView(viewModel: SendOfferViewModel(coordinator: coordinator, orderModel: orderModel), items: items)
                        .navigationBarHidden(true)
                case .BanckAccountDetails(model:let item):
                    BanckAccountDetailsView(viewModel: BanckAccountDetailsViewModel(coordinator: coordinator),item: item)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}
