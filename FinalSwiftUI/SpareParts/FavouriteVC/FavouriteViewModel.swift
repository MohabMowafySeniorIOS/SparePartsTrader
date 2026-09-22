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
    @Published var isLoadingMore: Bool = false
    private var currentPage = 1
    private var isLoading: Bool = false
    private var requestToken = 0
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        refresh()
    }
    
    // MARK: - Pagination
    func refresh() {
        requestToken += 1          // ignore any in-flight response of the old list
        currentPage = 1
        canLoadMore = false
        isLoading = false
        isLoadingMore = false
        getFavourite()
    }
    
    func loadMoreIfNeeded(currentTrader: Trader) {
        guard let last = traders.last else { return }
        
        if (currentTrader.id == last.id) && canLoadMore && !isLoading {
            getFavourite()
        }
    }
    
    
    func getFavourite(urlEndPoint:EndPoints = .favorites, methodType: HTTPMethodType = .get) {
        guard !isLoading else { return }
        let page = currentPage
        let token = requestToken
        let url = "\(hostName)\(urlEndPoint.rawValue)?page=\(page)"
        isLoading = true
        if page == 1 {
            state = .loading(loading: .progress)
        } else {
            isLoadingMore = true
        }
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModelPaginate<[Trader]>? , err : String? )in
            guard let self = self, token == self.requestToken else { return }
            self.isLoading = false
            self.isLoadingMore = false
            if Model?.status == "success" {
                let newItems = Model?.data?.data ?? []
                if page == 1 {
                    traders = newItems
                } else {
                    traders.append(contentsOf: newItems)
                }
                
                if page < (Model?.data?.lastPage ?? 0) {
                    currentPage = page + 1
                    canLoadMore = true
                } else {
                    canLoadMore = false
                }
                
                state = .loaded(data: traders)
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
