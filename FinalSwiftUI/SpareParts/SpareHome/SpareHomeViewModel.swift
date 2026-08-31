//
//  SpareHomeModel.swift
//  MyAuctions
//
//  Created by Mohab on 09/07/2025.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

class SpareHomeViewModel: ObservableObject {
    
    @Published var state: viewState<HomeResponse?> = .idle
    @Published var tradersArr = [Trader]()
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        getHomeData()
    }
    
    func showCreateOrder(mainOrderType: CreateOrderType,specificVendor: Trader?) {
        self.coordinator.createOrder(mainOrderType: mainOrderType, specificVendor: specificVendor)
    }
   
    
    func getHomeData() {
        let url = "\(hostName)\(EndPoints.home.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters:nil) { [weak self] (Model: BaseModel<HomeResponse>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.state = .loaded(data: Model?.data)
                tradersArr = Model?.data?.topTraders ?? []
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
        
    func handleFavourite(vendor: Trader) {
        let url = "\(hostName)\(EndPoints.vendorDetails.rawValue)\(vendor.id)/favorite"
            
            APIClient.shared.performRequestWithAlamofire(urlString: url, method: .post, parameters: ["trader": "\(vendor.id)"]) { [weak self] (Model: BaseModel<IsFavouriteModel>? , err : String? )in
                guard let self = self else { return }
                if Model?.status == "success" {
                    DispatchQueue.main.async {
                        guard let index = self.state.data??.topTraders?.firstIndex(where: { $0.id == vendor.id }) else { return }
                        self.tradersArr[index].isFavorite.toggle()
                        
                    }
                    
                }else {
                    self.state = .error(err ?? "")
                }
                
            }
        }
    
}
