//
//  MyCarsViewModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/12/25.
//

import Foundation
import Foundation
import Combine

import SwiftUI
class MyCarsViewModel: ObservableObject {
    
    @Published var myCars = [CarsData]()
    @Published var state: viewState<[CarsData]> = .idle
    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        getMyCars()
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
   
    func getMyCars(urlEndPoint:EndPoints = .profile_cars, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        print(url)
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[CarsData]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 myCars = Model?.data ?? []
                 if myCars.count > 0 {
                     self.state = .loaded(data: Model?.data ?? [])
                 }else {
                     self.state = .emptyScreen
                 }
                 
           }else {
               self.state = .error(err ?? "")
           }
            
        }
    }
    
    func deleteCars(urlEndPoint:EndPoints = .profile_cars, car_id: String, methodType: HTTPMethodType = .delete) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(car_id)"
        print(url)
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<String>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.myCars.removeAll { "\($0.id ?? 0)" == car_id }
                 if myCars.count > 0 {
                     self.state = .loaded(data: self.myCars ?? [])
                 }else {
                     self.state = .emptyScreen
                 }
           }else {
               state = .error(err ?? "")
           }
        }
    }
}

