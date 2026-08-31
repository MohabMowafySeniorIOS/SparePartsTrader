//
//  AddCarViewModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 17/07/2025.
//

import Foundation
import Combine
import SwiftUI

class ChooseCountryAndCityViewModel: ObservableObject {
   
    @Published var countryArray = [CountryData]()
    @Published var cityArray = [CityData]()
    @Published var selectedCcountry: CountryData? = nil
   
    
    @Published var state: viewState<CarsData?> = .idle
    

    init() {
       
        fetchCountries()
        fetchCities()
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
    
}

