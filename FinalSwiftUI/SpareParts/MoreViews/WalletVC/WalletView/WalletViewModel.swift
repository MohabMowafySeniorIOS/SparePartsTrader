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
    
    @ObservedObject var coordinator: MainCoordinator
    init(coordinator: MainCoordinator){
        _coordinator = ObservedObject(wrappedValue: coordinator)
       getTransActions(type: "deposit", page: "1")
        getBalance()
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func getWithDraw(urlEndPoint:EndPoints = .WalletWithDrawRequest, methodType: HTTPMethodType = .get ,page:String) {
        let url = "\(hostName)\(urlEndPoint.rawValue)?page=\(page)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<TransactionsData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 walletModel = Model?.data?.data ?? []
                 state = .loaded(data: self.state.data)
            }else {
                state = .error(err ?? "")
            }
        }
    }
    
    func getTransActions(urlEndPoint:EndPoints = .WalletTransAction, methodType: HTTPMethodType = .get  ,type:String,page:String) {
        let url = "\(hostName)\(urlEndPoint.rawValue)?type=\(type)&page=\(page)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<TransactionsData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                walletModel = Model?.data?.data ?? []
                 state = .loaded(data: Model?.data?.data ?? [])
                 if walletModel.count == 0 {
                     state = .emptyScreen
                 }
            }else {
                state = .error(err ?? "")
            }
        }
    }
    
    func getBalance(urlEndPoint:EndPoints = .WalletBalanace, methodType: HTTPMethodType = .get ) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
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


