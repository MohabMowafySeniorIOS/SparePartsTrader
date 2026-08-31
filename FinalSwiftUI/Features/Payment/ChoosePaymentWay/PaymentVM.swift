//
//  PaymentVM.swift
//  SpareParts
//
//  Created by Mohab on 25/02/2026.
//

import SwiftUI
import Combine

final class PaymentVM: ObservableObject {
    var orderId = ""
    @Published var gateways: [Gateway] = []

    @Published var selectedGateway: Gateway?
    @Published var selectedBrand: BrandGateway?
    
    @Published var state: viewState<[Gateway]> = .idle
   
    @ObservedObject var coordinator: MainCoordinator
    
    
    init(coordinator: MainCoordinator, orderId: String) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.orderId = orderId
        getGetWays()
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
  
  

    var canContinue: Bool {
        guard let gateway = selectedGateway else { return false }
        if gateway.requiresBrand {
            return selectedBrand != nil
        }
        return true
    }
    
    func getGetWays(urlEndPoint:EndPoints = .AvailablePaymentMethod, methodType: HTTPMethodType = .get ) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters:nil) { [weak self] (Model: BaseModel<PaymentData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 gateways = Model?.data?.gateways ?? []
                 state = .loaded(data: Model?.data?.gateways ?? [])
             }else {
                 state = .error(err ?? "")
             }
        }
    }
    
    func checkOut(urlEndPoint:EndPoints = .orders, methodType: HTTPMethodType = .post, paramter: BaseParameters ) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(orderId)/checkout"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters:paramter.toDictionary()) { [weak self] (Model: BaseModel<checkOutModel>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 self.coordinator.showPaymentScreen(url: Model?.data?.redirect_url ?? "")
             }else {
                 state = .error(err ?? "")
             }
        }
    }

}
