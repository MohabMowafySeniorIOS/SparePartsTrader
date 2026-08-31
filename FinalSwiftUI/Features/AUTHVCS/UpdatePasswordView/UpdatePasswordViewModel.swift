//
//  changePasswordViewModel.swift
//  MyAuctions
//
//  Created by Mohab on 30/06/2025.
//


import Foundation
import Combine
import SwiftUI

class UpdatePasswordViewModel: ObservableObject {
    @Published var userData: String?
    @Published var state: viewState<LoginData?> = .idle
    @ObservedObject private var coordinator: MainCoordinator
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func changePasswordSuccessFully(){
        coordinator.path.removeLast()
    }
    
    func ChangePassword(urlEndPoint:EndPoints = .update_password, methodType: HTTPMethodType = .post ,parameters : BaseParameters) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<LoginData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 self.state = .loaded(data: Model?.data)
                self.changePasswordSuccessFully()
                
             }else {
                 state = .error(err ?? "")
             }
        }
    }
}

