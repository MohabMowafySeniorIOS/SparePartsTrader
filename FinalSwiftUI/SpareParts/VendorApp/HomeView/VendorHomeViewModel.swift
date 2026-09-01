//
//  VendorHomeViewModel.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//


import Foundation
import Combine
import SwiftUI

class VendorHomeViewModel: ObservableObject {
    
    @Published var state: viewState<VendorHomeData?> = .idle
    @Published var isRecivingOrder: Bool = false
    @Published var unreadNotificationsCount: Int = 0
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        getHomeData()
        getUnreadNotificationsCount()
    }
    
    func showCreateOrder(mainOrderType: CreateOrderType,specificVendor: Trader?) {
        self.coordinator.createOrder(mainOrderType: mainOrderType, specificVendor: specificVendor)
    }
   
    
    func getUnreadNotificationsCount() {
        guard AuthService.userData?.token != nil else {
            self.unreadNotificationsCount = 0
            return
        }
        let url = "\(hostName)\(EndPoints.notifications.rawValue)?page=1"
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters: nil) { [weak self] (Model: NotificationModel? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                DispatchQueue.main.async {
                    self.unreadNotificationsCount = Model?.unread_count ?? 0
                }
            }
        }
    }
    
    func getHomeData() {
        let url = "\(hostName)\(EndPoints.statistics.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters:nil) { [weak self] (Model: BaseModel<VendorHomeData>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.state = .loaded(data: Model?.data)
                self.isRecivingOrder = Model?.data?.is_receiving_orders ?? false
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
    
    func toggleRecievingOrder(status: Bool) {
        let url = "\(hostName)\(EndPoints.toggleReceivingOrder.rawValue)?is_receiving_orders=\(status)"
      
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .post, parameters:nil) { [weak self] (Model: BaseModel<RecivingOrderModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.isRecivingOrder = Model?.data?.is_receiving_orders ?? false
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
        
       
}
