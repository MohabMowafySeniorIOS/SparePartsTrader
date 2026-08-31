//
//  TermsViewModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/7/25.
//

import Foundation
import Combine

import SwiftUI
class TermsViewModel: ObservableObject {
    @Published var state: viewState<String?> = .idle
    @Published var content: String?
    @Published var pageTitle : String?
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    
    func disMiss(){
        coordinator.path.removeLast()
    }
   
    func getTerms(urlEndPoint:EndPoints = .showPage, tailUrl: String, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(tailUrl)"
        print(url)
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<TermsResponse>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.content = Model?.data?.content ?? ""
                self.pageTitle = Model?.data?.title ?? ""
                 state = .loaded(data: Model?.data?.content ?? "")
             }else {
                 state = .error(err ?? "")
             }
        }
    }
}

