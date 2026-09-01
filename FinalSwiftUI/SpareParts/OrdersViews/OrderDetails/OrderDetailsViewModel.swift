//
//  OrderDetailsViewModel.swift
//  SpareParts
//
//  Created by Mohamed Elboraey on 10/02/2026.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

class OrderDetailsViewModel: ObservableObject {
    
    @Published var state: viewState<OrderDetailsModel> = .idle
   
    @Published var problemTypes = [OrderType]()
    @ObservedObject var coordinator: MainCoordinator
    var orderId: String
    init(coordinator: MainCoordinator, orderId: String) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.orderId = orderId
        getOrderData(orderId: orderId)
        getProblemTypes()
    }
    
    
    
    /// فتح المحادثة مع العميل: لو فيه شات موجود يفتحه، غير كده ينشئ واحد جديد
    func openChat(with data: OrderDetailsModel?,title: String) {
        if let chatId = data?.chatID, chatId > 0 {
            coordinator.showChatView(roomId: "\(chatId)", title: title)
            return
        }

//        var param = BaseParameters()
//        param.order_id = "\(data?.id ?? 0)"
//        param.client_id = "\(data?.client?.id ?? 0)"
//        createChat(param: param)
    }

//    func createChat(urlEndPoint:EndPoints = .chats, methodType: HTTPMethodType = .post ,param: BaseParameters) {
//        let url = "\(hostName)\(urlEndPoint.rawValue)"
//        state = .loading(loading: .progress)
//        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: param.toDictionary()) { [weak self] (Model: BaseModel<RecieptModel>? , err : String? )in
//            guard let self = self else { return }
//            if Model?.status == "success" {
//               self.coordinator.showChatView(roomId: "\(data.chatID ?? 0)")
//            }else {
//                state = .error(err ?? "")
//            }
//        }
   // }
    func getProblemTypes() {
        let url = "\(hostName)trader/problems/types"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters:nil) { [weak self] (Model: BaseModel<[OrderType]>? , err : String? )in
            guard let self = self else { return }
            if Model != nil {
                self.state = .loaded(data: self.state.data)
                self.problemTypes = Model?.data ?? []
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
    
    func getBill() {
        let url = "\(hostName)orders/\(orderId)/invoice"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters:nil) { [weak self] (Model: BaseModel<InvoiceDetailsModel>? , err : String? )in
            guard let self = self else { return }
            if Model != nil {
                
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
    
    
    func getOrderData(orderId: String) {
        let url = "\(hostName)\(EndPoints.orders.rawValue)/\(orderId)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters:nil) { [weak self] (Model: BaseModel<OrderDetailsModel>? , err : String? )in
            guard let self = self else { return }
            if Model != nil {
                self.state = .loaded(data: Model?.data)
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
    func recept(urlEndPoint:EndPoints = .orders, methodType: HTTPMethodType = .post, orderId: String) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(orderId)/confirm-receipt"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<RecieptModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                getOrderData(orderId: orderId)
            }else {
                state = .error(err ?? "")
            }
        }
    }
    
    func payMent(urlEndPoint:EndPoints = .orders, methodType: HTTPMethodType = .post, orderId: String) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(orderId)/confirm-receipt"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<String>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                getOrderData(orderId: orderId)
            }else {
                state = .error(err ?? "")
            }
        }
    }
    
    func updateStatus(methodType: HTTPMethodType = .post, urlEndPoint: String) {
        let url = "\(hostName)trader/orders/\(self.orderId)/update-status"
        let parameter = BaseParameters.init(status: urlEndPoint)
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameter.toDictionary()) { [weak self] (Model: BaseModel<OrderDetailsModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.state = .loaded(data: Model?.data)
               // getOrderData(orderId: orderId)
            }else {
                state = .error(err ?? "")
            }
        }
    }
}
