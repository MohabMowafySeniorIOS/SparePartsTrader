//
//  CreaeOrderViewModel.swift
//  MyAuctions
//
//  Created by Mohab on 14/07/2025.
//

import Foundation
import Foundation
import Combine

import SwiftUI


class CreateOrderViewModel: ObservableObject {
    @Published var myCars       = [CarsData]()
    @Published var selectedCar:  CarsData? = nil
    @Published var myAddresses = [AddressData]()
    @Published var selectedAddresses: AddressData? = nil
    @Published  var partsPiece: [PartModel] = []
    @Published  var countryAndCities: [CountryAndCitiesModel] = []
    @Published var specificVendor: Trader?
    @Published  var targets: [Targets] = []
    @Published var state: viewState<BaseModel<CreateOrderModel>?> = .idle

    @ObservedObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator,specificVendor: Trader?) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.specificVendor = specificVendor
        getMyCars()
        getAddressAgenda()
    }
    
    func disMiss(){
        coordinator.disMiss()
    }
    
    func CreateOrder(urlEndPoint:EndPoints = .orders, methodType: HTTPMethodType = .post ,parameters : BaseParameters) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        var dict = parameters.toDictionary()
        let parts = partsPiece
        if parts.count > 0 {
            for item in 0...parts.count - 1 {
                dict["items[\(item)][part_name]"] = parts[item].name
                dict["items[\(item)][part_number]"] = parts[item].number
                dict["items[\(item)][part_type]"] = parts[item].type
                dict["items[\(item)][quantity]"] = parts[item].quantity
                dict["items[\(item)][description]"] = parts[item].describtion
            }
        }
        if targets.count > 0 {
            for item in 0...targets.count - 1{
                dict["targets[\(item)][type]"] = targets[item].type
                dict["targets[\(item)][id]"] = "\(targets[item].id ?? 0)"
            }
        }
       
       
        APIClient.shared.uploadMultipartWithAlamofire(urlString: url,parameters: dict) { [weak self] (Model: BaseModel<CreateOrderModel>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
            //    <#modelName#> = Model?.data
                 self.state = .loaded(data: Model)
            }else {
                self.state = .error(err ?? "")
            }
           
        }
    }
    
    func getMyCars(urlEndPoint:EndPoints = .profile_cars, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        print(url)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[CarsData]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 myCars = Model?.data ?? []
           }else {
              
           }
            
        }
    }
    
    func getAddressAgenda(urlEndPoint: EndPoints = .client_addresses, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        
        APIClient.shared.performRequestWithAlamofire(
            urlString: url, method: methodType, parameters: nil
        ) { [weak self] (Model: BaseModel<[AddressData]>?, err: String?) in
            guard let self = self else { return }
             if Model?.status == "success" {
                myAddresses = Model?.data ?? []
                 
                 
           }else {
               
           }
        }
    }
}


