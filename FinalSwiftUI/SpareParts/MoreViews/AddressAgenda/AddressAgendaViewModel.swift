//
//  AddressAgendaViewModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 20/07/2025.
//


import Combine
import Foundation
import SwiftUI

class AddressAgendaViewModel: ObservableObject {
    @Published var state: viewState<[AddressData]> = .idle
    @Published var myAddresses = [AddressData]()
   
    @ObservedObject var coordinator: MainCoordinator
    init(coordinator: MainCoordinator){
        _coordinator = ObservedObject(wrappedValue: coordinator)
        getAddressAgenda()
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func deleteAddressAgenda(urlEndPoint: EndPoints = .client_addresses,id:String, methodType: HTTPMethodType = .delete) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(id)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(
            urlString: url, method: methodType, parameters: nil
        ) { [weak self] (Model: BaseModel<[AddressData]>?, err: String?) in
            guard let self = self else { return }
             if Model?.status == "success" {
                 myAddresses.removeAll { "\($0.id ?? 0)" == id }
                 if myAddresses.count > 0 {
                     self.state = .loaded(data: Model?.data ?? [])
                 }else {
                     self.state = .emptyScreen
                 }
            } else {
                state = .error(err ?? "")
            }
        }
    }

    func getAddressAgenda(urlEndPoint: EndPoints = .client_addresses, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(
            urlString: url, method: methodType, parameters: nil
        ) { [weak self] (Model: BaseModel<[AddressData]>?, err: String?) in
            guard let self = self else { return }
             if Model?.status == "success" {
                myAddresses = Model?.data ?? []
                 if myAddresses.count > 0 {
                     self.state = .loaded(data: Model?.data ?? [])
                 }else {
                     self.state = .emptyScreen
                 }
                 
           }else {
               self.state = .error(err ?? "")
           }
        }
    }
}
