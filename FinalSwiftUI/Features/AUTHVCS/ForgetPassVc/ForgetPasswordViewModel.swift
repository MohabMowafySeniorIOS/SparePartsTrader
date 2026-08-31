//
//  ForgetPasswordViewModel.swift
//  MyAuctions
//
//  Created by Mohab on 07/06/2025.
//

import Foundation
import Foundation
import Combine

import SwiftUI
class ForgetPasswordViewModel: ObservableObject {
    @Published var Model: ResendOTPModel?
    @Published var state: viewState<ResendOTPModel?> = .idle
    
    private let coordinator: AuthCoordinator
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func pop() {
        coordinator.pop()
    }
    
    func showVerify(isForget:Bool, phone: String){
        coordinator.showVerify(isForgetPass: isForget, phone: phone)
    }
    
    
    func forgotPass(urlEndPoint:EndPoints, methodType: HTTPMethodType  ,parameters : BaseParameters) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<ResendOTPModel>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.Model = Model?.data
                 state = .loaded(data: Model?.data)
            }else {
                state = .error(err ?? "")
            }
        }
    }
}

