//
//  WithDrawViewModel.swift
//  SpareParts
//
//  Created by Mohab on 12/02/2026.
//

import Foundation
import Combine

import SwiftUI
class BanckAccountDetailsViewModel: ObservableObject {
 
    @Published var state: viewState<WithDrawData> = .idle
    
    
    @ObservedObject private var coordinator: MainCoordinator
    init(coordinator: MainCoordinator){
        _coordinator = ObservedObject(wrappedValue: coordinator)
       
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func withDraw(urlEndPoint:EndPoints = .WalletWithDraw, methodType: HTTPMethodType = .post  ,parameters : BaseParameters) {
        let phone = parameters.toDictionary()["auth"] as? String
        print(phone,parameters.toDictionary())
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<WithDrawData>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                state = .loaded(data: Model?.data)
                disMiss()
               
            }else {
                state = .error(err ?? "")
            }
        }
    }
    
    

}


