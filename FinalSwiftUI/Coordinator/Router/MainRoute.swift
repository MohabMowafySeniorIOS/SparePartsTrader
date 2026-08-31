//
//  MainRoute.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation

enum MainRoute: Equatable, Hashable {
  
    
    case createOrder(mainOrderType: CreateOrderType ,specificVendor: Trader?)
    //case addPiece
    case vendorDetails(rating: Double , vendorId: String)
    case showNotification
    case OrderDetailsView(orderId: String)
    case SendOfferView(orderModel: OrderDetailsModel?,ItemsModel:[DataItem])
    case BanckAccountDetails(model: TransactionItem?)
    //MARK: MoreVC
    case MyCars
    case GatWay(orderId: String)
    case FileBusniss
    case UpdateFileBusniss(userModel: LoginData?)
    case MyAddress
    case AddAddress(addressModel: AddressData?)
    case Wallet
    case WithDraw
    case messages
    case chatView(roomId: String)
    case settings
    case FAQ
    case About_us(page: String)
    case Contact
    case Profile
    case addCar(carId: CarsData?)
    case updatePassword
    case updatePhone
    case updateOtp(phone: String)
    case offerDetails(offerId: String, orderId: String, OfferModel: Offer?)
    case paymentScreen(url: String)
}
