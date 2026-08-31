//
//  GenaricOrderBottomSheetViewModel.swift
//  SpareParts
//
//  Created by Mohamed Elboraey on 12/02/2026.
//

import Foundation
import SwiftUI
import Combine

class GenaricOrderBottomSheetViewModel: ObservableObject {
    @Published var state: viewState<OrderCancelModel> = .idle
    var onSuccess: (() -> Void)? = nil
    
    func rate(urlEndPoint:EndPoints = .orders, methodType: HTTPMethodType = .post, orderId: String, parameters : BaseParameters) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(orderId)/rate"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<OrderCancelModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                state = .loaded(data: Model?.data)
                onSuccess?()
            }else {
                state = .error(err ?? "")
                onSuccess?()
            }
        }
    }
    
    func cancel(urlEndPoint:EndPoints = .orders, methodType: HTTPMethodType = .post, orderId: String, parameters : BaseParameters) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(orderId)/cancel"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<OrderCancelModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                state = .loaded(data: Model?.data)
                onSuccess?()
            }else {
                state = .error(err ?? "")
            }
        }
    }
    
    func report(urlEndPoint:EndPoints = .orders, methodType: HTTPMethodType = .post, orderId: String, parameters : BaseParameters) {
        let url = "\(hostName)trader/problems/order/\(orderId)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<OrderCancelModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                state = .loaded(data: Model?.data)
                onSuccess?()
            }else {
                state = .error(err ?? "")
            }
        }
    }
}
