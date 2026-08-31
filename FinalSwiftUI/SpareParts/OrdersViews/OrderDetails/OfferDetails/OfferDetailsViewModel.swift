//
//  OfferDetailsViewModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//

import Foundation
import Combine
import SwiftUI
class OfferDetailsViewModel: ObservableObject {
   
    @Published var state: viewState<String> = .idle
    var offerId: String
    var orderId: String
    var OfferModel: Offer?
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator, offerId: String, orderId: String, OfferModel: Offer?) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.offerId = offerId
        self.orderId = orderId
        self.OfferModel = OfferModel
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func getOfferDetails(urlEndPoint:EndPoints, methodType: HTTPMethodType) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<String>? , err : String? )in
            guard let self = self else { return }
             if err == nil {
                 state = .loaded(data: Model?.data ?? "")
            }else {
                state = .error(err ?? "")
            }
           
        }
    }
    
    func acceptOffer(urlEndPoint:EndPoints = .orders, methodType: HTTPMethodType = .post, order_id: String,offer_id: String) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(order_id)/accept-offer"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: ["offer_id": offer_id]) { [weak self] (Model: BaseModel<OfferDetailsModel>? , err : String? )in
            guard let self = self else { return }
             if err == nil {
                 coordinator.showGatWay(orderId: orderId)
             }else {
                 state = .error(err ?? "")
             }
        }
    }
}

