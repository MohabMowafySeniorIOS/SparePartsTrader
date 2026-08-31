//
//  FAQViewModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/8/25.
//

import Foundation
import Foundation
import Combine

import SwiftUI
class FAQViewModel: ObservableObject {
    @Published var state: viewState<[FAQ]> = .idle
    @Published var ModelFAQ = [FAQ]()
    
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        getFAQS()
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func getFAQS(urlEndPoint:EndPoints = .faq, methodType: HTTPMethodType = .get ) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters:nil) { [weak self] (Model: BaseModel<[FAQ]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                ModelFAQ = Model?.data ?? []
                 state = .loaded(data: Model?.data ?? [])
             }else {
                 state = .error(err ?? "")
             }
        }
    }
}

