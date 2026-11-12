//
//  sidMenueViewModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/26/25.
//


import Foundation
import Combine

import SwiftUI

class sidMenueViewModel: ObservableObject {
    
    @Published var logOutModel: String?
    @Published var pagesArray = [String]()
    @Published var state: viewState<String?> = .idle
    
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        getPages()
    }
   
    
    func showFAQ(){
        self.coordinator.showFAQ()
    }
    
    func showlogOut(){
        self.coordinator.logOut()
    }
    
    func getPages(urlEndPoint:EndPoints = .pages, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[String]>? , err : String? )in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if Model?.status == "success" {
                    self.pagesArray = Model?.data ?? []
                } else {
                    self.state = .error(err ?? Model?.message ?? "")
                }
            }
        }
    }
    
    func logOut(urlEndPoint:EndPoints = .logout, methodType: HTTPMethodType = .post) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<String>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                logOutModel = Model?.data ?? ""
             }else {
                 state = .error(err ?? "")
             }
            self.showlogOut()
        }
    }
    
    func DeleteAccount(urlEndPoint:EndPoints = .account_request_deletion, methodType: HTTPMethodType = .post) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<String>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                logOutModel = Model?.data ?? ""
             }else {
                 state = .error(err ?? "")
             }
            self.showlogOut()
        }
    }
}

