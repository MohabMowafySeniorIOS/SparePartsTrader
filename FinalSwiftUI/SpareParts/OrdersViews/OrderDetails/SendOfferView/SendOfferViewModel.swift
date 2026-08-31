//
//  OfferDetailsViewModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//

import Foundation
import Combine
import SwiftUI
import Alamofire
struct offerParts {
    var order_item_id: String
    var price: String
    var is_available: String
}

class SendOfferViewModel: ObservableObject {
   
    @Published var state: viewState<SendOfferData> = .idle
    var orderModel: OrderDetailsModel?
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator, orderModel: OrderDetailsModel?) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.orderModel = orderModel
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func sendOffer(urlEndPoint:EndPoints = .orders, methodType: HTTPMethod = .post ,parts : [offerParts],shipping_cost:String,orderId: String,offerId: String) {
        var url = "\(hostName)trader/offers/order/\(orderId)"
        var methodType = methodType
        if offerId != "0" {
            url = "\(hostName)trader/offers/\(offerId)"
            methodType = .post
        }
       
        state = .loading(loading: .progress)
        var dict = [String:String]()
        dict["shipping_cost"] = shipping_cost
        if parts.count > 0 {
            for item in 0...parts.count - 1 {
                dict["items[\(item)][order_item_id]"] = parts[item].order_item_id
                dict["items[\(item)][price]"] = parts[item].price
                dict["items[\(item)][is_available]"] = "1"
            }
        }
      
       
        APIClient.shared.uploadMultipartWithAlamofire(urlString: url,parameters: dict,methodType: methodType) { [weak self] (Model: BaseModel<SendOfferData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
            //    <#modelName#> = Model?.data
                 self.state = .loaded(data: Model?.data)
                 self.disMiss()
            }else {
                self.state = .error(err ?? "")
            }
           
        }
    }
    
   
}

