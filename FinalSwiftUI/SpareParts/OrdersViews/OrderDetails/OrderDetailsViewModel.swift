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
    @Published var reportedProblem: problem_reportModel?
   
    @Published var problemTypes = [OrderType]()
    @Published var cancellationReasons = [CancellationReason]()
    @ObservedObject var coordinator: MainCoordinator
    var orderId: String
    private let reportedProblemID: String?
    init(coordinator: MainCoordinator, orderId: String, problemId: String? = nil) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.orderId = orderId
        self.reportedProblemID = problemId
        getOrderData(orderId: orderId)
        getProblemTypes()
        getCancellationReasons()
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

    func getCancellationReasons() {
        let url = "\(hostName)trader/orders/cancellation-reasons"
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters: nil) { [weak self] (model: BaseModel<[CancellationReason]>?, err: String?) in
            guard let self = self else { return }
            if model?.status == "success" {
                self.cancellationReasons = model?.data ?? []
            } else if self.cancellationReasons.isEmpty {
                let message = err ?? model?.message ?? "unknown error"
                print("Failed to load trader cancellation reasons: \(message)")
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
            if let order = Model?.data {
                self.reportedProblem = order.problemReports?.first ?? order.problemReport
                self.state = .loaded(data: Model?.data)
                if order.problemReports?.isEmpty != false, order.problemReport == nil, let orderID = order.id {
                    self.getReportedProblem(orderId: orderID, orderNumber: order.orderNumber)
                    if let reportedProblemID, !reportedProblemID.isEmpty {
                        self.getReportedProblem(problemId: reportedProblemID, expectedOrderID: orderID, expectedOrderNumber: order.orderNumber)
                    }
                }
            } else {
                self.state = .error(err ?? "")
            }
        }
    }

    /// The order endpoint does not consistently include its problem report.
    /// The documented trader problems index does, so use it as a fallback and
    /// match by the order's numeric ID without interrupting order rendering.
    private func getReportedProblem(orderId: Int, orderNumber: String?) {
        let url = "\(hostName)trader/problems"
        let matchesOrder: (problem_reportModel) -> Bool = { report in
            report.order_id == orderId ||
            (orderNumber?.isEmpty == false && report.order_number == orderNumber)
        }
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters: nil) { [weak self] (model: BaseModelPaginate<[problem_reportModel]>?, _: String?) in
            guard let self else { return }
            let reports = model?.data?.data ?? []
            let matchingReport = reports.first(where: matchesOrder)
            self.setReportedProblem(matchingReport)
        }
    }

    private func getReportedProblem(problemId: String, expectedOrderID: Int? = nil, expectedOrderNumber: String? = nil) {
        let url = "\(hostName)trader/problems/\(problemId)"
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters: nil) { [weak self] (model: BaseModel<problem_reportModel>?, _: String?) in
            guard let self else { return }
            guard let report = model?.data else { return }
            if let expectedOrderID,
               report.order_id != expectedOrderID && report.order_number != expectedOrderNumber {
                return
            }
            self.setReportedProblem(report)
        }
    }

    private func setReportedProblem(_ report: problem_reportModel?) {
        guard let report else { return }
        DispatchQueue.main.async { self.reportedProblem = report }
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
    
    
    func cancelOffer(methodType: HTTPMethodType = .post, offerId: String) {
        let url = "\(hostName)trader/offers/\(offerId)/cancel"
        print(url)
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<SendOfferData>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                getOrderData(orderId: orderId)
            }else {
                state = .error(err ?? "")
            }
        }
    }

    /// Sends an offer for the order with every requested part marked unavailable.
    func sendEmptyOfferForCancellation() {
        var url = "\(hostName)trader/offers/order/\(orderId)"
        var methodType: HTTPMethod = .post
        if let offerId = state.data?.myOffer?.id, offerId != 0 {
            url = "\(hostName)trader/offers/\(offerId)"
            methodType = .post
        }

        var parameters: [String: Any] = ["shipping_cost": "0"]
        let orderItems = state.data?.items ?? []
        for (index, item) in orderItems.enumerated() {
            guard let orderItemID = item.id else { continue }
            parameters["items[\(index)][order_item_id]"] = orderItemID
            parameters["items[\(index)][price]"] = 0.0
            parameters["items[\(index)][is_available]"] = 0
        }

        state = .loading(loading: .progress)
        APIClient.shared.uploadMultipartWithAlamofire(
            urlString: url,
            parameters: parameters,
            methodType: methodType
        ) { [weak self] (model: BaseModel<SendOfferData>?, error: String?) in
            guard let self else { return }
            if model?.status == "success" {
                self.getOrderData(orderId: self.orderId)
            } else {
                self.state = .error(error ?? model?.message ?? "unknown error")
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
