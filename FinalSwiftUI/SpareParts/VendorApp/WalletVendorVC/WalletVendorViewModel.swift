//
//  WalletVendorViewModel.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//

import Foundation
import Combine
import SwiftUI

class VendorWalletViewModel: ObservableObject {
    let items: [WithdrawalItem] = Array(repeating:
        WithdrawalItem(
            index: 1,
            referenceNumber: "122525",
            requestNumber: "55252",
            amount: "200 ر.س",
            date: "15/2/2025",
            time: "7:25 ص"
        ),
        count: 4
    )
    
    @Published var state: viewState<HomeResponse?> = .idle
    
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
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
        
       
}
