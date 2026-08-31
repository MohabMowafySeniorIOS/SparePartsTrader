//
//  RegisterViewModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//


import Foundation
import Combine
import SwiftUI

final class RegisterViewModel: ObservableObject {

    @Published var userData: LoginData?
    @Published var state: viewState<LoginData?> = .idle
    
    @Published var countryArray = [CountryData]()
    @Published var cityArray = [CityData]()
    @Published var selectedCcountry: CountryData? = nil
    @Published var selectedCity: CityData? = nil
    
    private let coordinator: AuthCoordinator
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        fetchCountries()
        fetchCities()
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func showOtp(phone: String,isForgetPass: Bool) {
        coordinator.showOTP(phone: phone, isForgetPass: isForgetPass)
    }
    
    func fetchCountries(urlEndPoint:EndPoints = .countries, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[CountryData]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.countryArray = Model?.data ?? []
             }else {
                 state = .error(err ?? "")
             }
        }
    }
    
    func fetchCities(urlEndPoint:EndPoints = .cities, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[CityData]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.cityArray = Model?.data ?? []
             }else {
                 state = .error(err ?? "")
             }
        }
    }
    
    func fetchUsers(urlEndPoint:EndPoints, methodType: HTTPMethodType  ,parameters : BaseParameters) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<String>? , err : String? )in
            guard let self = self else { return }

            if Model?.status == "success" {

            self.showOtp(phone: parameters.phone, isForgetPass: false)

            }else {
                state = .error(err ?? "")
            }
        }
    }
}

