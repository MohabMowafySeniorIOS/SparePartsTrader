//
//  MainCoordinatorView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation
import SwiftUI

final class MainCoordinator: ObservableObject {

    @Published var path = NavigationPath()
       
    
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    
    // MARK: Home
    func showNotification() {
        path.append(MainRoute.showNotification)
    }
    
    func createOrder(mainOrderType: CreateOrderType, specificVendor: Trader?) {
        path.append(MainRoute.createOrder(mainOrderType: mainOrderType, specificVendor: specificVendor))
    }
    
//    func addPiece(pieces: Binding<[PartModel]>){
//        path.append(MainRoute.addPiece)
//    }
    
    func vendorDetails(rating: Double , vendorId: String) {
        path.append(MainRoute.vendorDetails(rating: rating, vendorId: vendorId))
    }
    
    
    
    
    
    
    //MARK: MoreVC
    func restartApp(){
       
            appCoordinator.flow = .auth
        
       
    }
    
    func logOut(){
        appCoordinator.flow = .auth
    }

   
    
    func showMyCars() {
        path.append(MainRoute.MyCars)
    }
    
    func showGatWay(orderId: String) {
        path.append(MainRoute.GatWay(orderId: orderId))
    }
    
    func BanckAccountDetails(model: TransactionItem?) {
        path.append(MainRoute.BanckAccountDetails(model: model))
    }
    
    func sendOfferView(orderModel: OrderDetailsModel?,ItemsModel:[DataItem]) {
        path.append(MainRoute.SendOfferView(orderModel: orderModel, ItemsModel: ItemsModel))
    }
    
    func showMyFileBusniss() {
        path.append(MainRoute.FileBusniss)
    }
    
    func showUpdateFileBusniss(userModel: LoginData?) {
        path.append(MainRoute.UpdateFileBusniss(userModel: userModel))
    }
    
    func showAddCars(carId: CarsData?) {
        path.append(MainRoute.addCar(carId: carId))
    }
    
    func showMyAddresses() {
        path.append(MainRoute.MyAddress)
    }
    
    func showAddAddresses(addressModel: AddressData?) {
        path.append(MainRoute.AddAddress(addressModel: addressModel))
    }
    
    func showWallet() {
        path.append(MainRoute.Wallet)
    }
    
    func showMessages() {
        path.append(MainRoute.messages)
    }
    
    func showChatView(roomId: String) {
        path.append(MainRoute.chatView(roomId: roomId))
    }
    
    
    func showSettings() {
        path.append(MainRoute.settings)
    }
    
    func showOrderDetails(orderId: String) {
        path.append(MainRoute.OrderDetailsView(orderId: orderId))
    }
    
    func showAboutUs(page: String) {
        path.append(MainRoute.About_us(page: page))
    }
    
    
    func showContact() {
        path.append(MainRoute.Contact)
    }
    
    func showProfile() {
        path.append(MainRoute.Profile)
    }
    
    func showFAQ() {
        path.append(MainRoute.FAQ)
    }
    
   
    func loginSuccess() {
        appCoordinator.flow = .main
    }
    
    func showUpdatePassword() {
        path.append(MainRoute.updatePassword)
    }
   
    func showPhoneScreen() {
        path.append(MainRoute.updatePhone)
    }
    
    func showOtpScreen(phone: String) {
        path.append(MainRoute.updateOtp(phone: phone))
    }
    
    func showWithDraw(){
        path.append(MainRoute.WithDraw)
        
    }
    
    func showOfferDetails(offerId: String, orderId: String, OfferModel: Offer) {
        path.append(MainRoute.offerDetails(offerId: offerId, orderId: orderId, OfferModel: OfferModel))
    }
    
    func showPaymentScreen(url: String) {
        path.append(MainRoute.paymentScreen(url: url))
    }
    
    func disMiss(){
        path.removeLast()
    }
}
