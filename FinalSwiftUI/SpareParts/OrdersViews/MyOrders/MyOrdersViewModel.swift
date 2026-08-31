//
//  MyOrdersViewModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 18/07/2025.
//

import Foundation
import Combine
import Alamofire
import SwiftUI


class MyOrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var state: viewState<MyOrdersCardModel> = .idle
    @ObservedObject var coordinator: MainCoordinator
    var canLoadMore: Bool = false
    private var currentPage = 1
    @Published var selectedOrderType: MyOrderType = .new {
        didSet {
            guard oldValue != selectedOrderType else { return }
            orders.removeAll()
            canLoadMore = false
            currentPage = 1
            getMyOrdersData()
        }
    }
    
    func refres(){
        orders.removeAll()
        canLoadMore = false
        currentPage = 1
        getMyOrdersData()
    }
   
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        getMyOrdersData()
    }
    
    func loadMoreIfNeeded(currentOrder: Order) {
        guard let last = orders.last else { return }
        
        if (currentOrder.id == last.id) && canLoadMore {
            getMyOrdersData()
        }
    }
    
    func getMyOrdersData() {
        let url = "\(hostName)trader/orders/my-orders?status_type=\(selectedOrderType.rawValue)&page=\(currentPage)"
        if currentPage == 1 {
            state = .loading(loading: .progress)
        }
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters: nil) { [weak self] (Model: BaseModel<MyOrdersCardModel>? , err : String? )in
            guard let self = self else { return }
           
            if Model?.status == "success" {
                self.orders.append(contentsOf: Model?.data?.data ?? [])
                if currentPage == 1 {
                state = .loaded(data: nil)
                }
                if self.currentPage < (Model?.data?.meta?.lastPage ?? 0) {
                    self.currentPage = self.currentPage + 1
                    self.canLoadMore = true
                }else {
        
                    self.canLoadMore = false
                }
               
                
                    if self.orders.isEmpty {
                        state = .emptyScreen
                    }else {
                       
                    }
              
                
            }else {
                state = .error(err ?? "")
            }
        }
    }
    
    func changeOrderType(to type: MyOrderType) {
            selectedOrderType = type
        }
}

