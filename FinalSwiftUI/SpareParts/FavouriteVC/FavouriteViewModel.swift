//
//  FavouriteViewModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/26/25.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

class FavouritsViewModel: ObservableObject {
    @Published var state: viewState<[Trader]?> = .idle
    @Published var traders:[Trader] = []
    var canLoadMore: Bool = false
    private var currentPage = 1
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        getFavourite()
    }
    func loadMoreIfNeeded(currentTrader: Trader) {
        guard let last = state.data??.last else { return }
        
        if (currentTrader.id == last.id) && canLoadMore {
            getFavourite()
        }
    }
    
    
    func getFavourite(urlEndPoint:EndPoints = .favorites, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)?page=\(currentPage)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModelPaginate<[Trader]>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                state = .loaded(data: Model?.data?.data)
                traders = Model?.data?.data ?? []
                if traders.count == 0 {
                    state = .emptyScreen
                }
            }else {
                state = .error(err ?? "")
            }
            
        }
    }
    
    func handleFavourite(traderModel: Trader) {
        
        let url = "\(hostName)\(EndPoints.vendorDetails.rawValue)\(traderModel.id)/favorite"
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .post, parameters: ["trader": "\(traderModel.id)"]) { [weak self] (Model: BaseModel<IsFavouriteModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                DispatchQueue.main.async {
                    guard let index = self.traders.firstIndex(where: { $0.id == traderModel.id }) else { return }
                    self.traders.remove(at: index)
                    self.traders = self.traders
                    if self.traders.count == 0 {
                        self.state = .emptyScreen
                    }
                }
            }else {
                self.state = .error(err ?? "")
            }
            
        }
    }
}
