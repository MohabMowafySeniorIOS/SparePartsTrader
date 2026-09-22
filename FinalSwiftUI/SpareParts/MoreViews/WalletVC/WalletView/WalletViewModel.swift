//
//  WalletModelView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/28/25.
//

import Foundation
import Combine

import SwiftUI
class WalletViewModel: ObservableObject {
    @Published var balanceModel: BalanceData?
    @Published var walletModel = [TransactionItem]()
    @Published var state: viewState<[TransactionItem]?> = .idle
    
    @Published var isLoadingMore: Bool = false
    var canLoadMore: Bool = false
    private var currentPage = 1
    private var isLoading: Bool = false
    private var requestToken = 0
    /// Which list is currently shown (used to load the next page of the same list)
    private var currentSource: WalletListSource = .transactions(type: "deposit")
    
    private enum WalletListSource: Equatable {
        case transactions(type: String)
        case withdrawRequests
    }
    
    @ObservedObject var coordinator: MainCoordinator
    init(coordinator: MainCoordinator){
        _coordinator = ObservedObject(wrappedValue: coordinator)
       getTransActions(type: "deposit", page: "1")
        getBalance()
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    // MARK: - Pagination
    func loadMoreIfNeeded(currentItem: TransactionItem) {
        guard let last = walletModel.last else { return }
        guard currentItem == last, canLoadMore, !isLoading else { return }
        switch currentSource {
        case .transactions(let type):
            getTransActions(type: type, page: "\(currentPage)")
        case .withdrawRequests:
            getWithDraw(page: "\(currentPage)")
        }
    }
    
    /// page "1" (or a new tab) starts a fresh list, any other page appends to the current one
    private func prepareRequest(source: WalletListSource, page: String) -> (page: Int, token: Int)? {
        let pageNumber = Int(page) ?? 1
        if pageNumber == 1 || source != currentSource {
            requestToken += 1
            currentSource = source
            currentPage = 1
            canLoadMore = false
            isLoading = false
            isLoadingMore = false
            walletModel = []
        }
        guard !isLoading else { return nil }
        isLoading = true
        if currentPage == 1 {
            state = .loading(loading: .progress)
        } else {
            isLoadingMore = true
        }
        return (currentPage, requestToken)
    }
    
    private func handleListResponse(_ Model: BaseModel<TransactionsData>?, err: String?, page: Int, token: Int) {
        guard token == requestToken else { return }
        isLoading = false
        isLoadingMore = false
        if Model?.status == "success" {
            let newItems = Model?.data?.data ?? []
            if page == 1 {
                walletModel = newItems
            } else {
                walletModel.append(contentsOf: newItems)
            }
            
            if page < (Model?.data?.meta?.lastPage ?? 0) {
                currentPage = page + 1
                canLoadMore = true
            } else {
                canLoadMore = false
            }
            
            state = .loaded(data: walletModel)
            if walletModel.count == 0 {
                state = .emptyScreen
            }
        } else {
            state = .error(err ?? "")
        }
    }
    
    func getWithDraw(urlEndPoint:EndPoints = .WalletWithDrawRequest, methodType: HTTPMethodType = .get ,page:String) {
        guard let request = prepareRequest(source: .withdrawRequests, page: page) else { return }
        let url = "\(hostName)\(urlEndPoint.rawValue)?page=\(request.page)"
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<TransactionsData>? , err : String? )in
            self?.handleListResponse(Model, err: err, page: request.page, token: request.token)
        }
    }
    
    func getTransActions(urlEndPoint:EndPoints = .WalletTransAction, methodType: HTTPMethodType = .get  ,type:String,page:String) {
        guard let request = prepareRequest(source: .transactions(type: type), page: page) else { return }
        let url = "\(hostName)\(urlEndPoint.rawValue)?type=\(type)&page=\(request.page)"
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<TransactionsData>? , err : String? )in
            self?.handleListResponse(Model, err: err, page: request.page, token: request.token)
        }
    }
    
    func getBalance(urlEndPoint:EndPoints = .WalletBalanace, methodType: HTTPMethodType = .get ) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<BalanceData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 balanceModel = Model?.data
             }else {
                 state = .error(err ?? "")
             }
        }
    }
    
    

}


