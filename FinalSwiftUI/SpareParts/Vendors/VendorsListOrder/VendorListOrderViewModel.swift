//
//  VendorListViewModel.swift
//  SpareParts
//
//  Created by Mohab on 16/02/2026.
//

import Foundation
import SwiftUI
import Combine
class VendorListOrderViewModel: ObservableObject {
    @Published  var countryAndCities: [CountryAndCitiesModel] = []
    @Published var filterObject: FilterObject = FilterObject()
    @Published var vendorData: TradersResponse?
    @Published var state: viewState<BaseModel<String>> = .idle
    private var cancellables = Set<AnyCancellable>()
    var canLoadMore: Bool = false
    private var currentPage = 1
    
    
    init() {
        observeSearch()
    }
    
    private func observeSearch() {
        $countryAndCities
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.getVendorsData()
            }
           .store(in: &cancellables)
        
        $filterObject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.getVendorsData()
            }
           .store(in: &cancellables)
    }
   
    func openGoogleMaps(lat: Double, lng: Double) {
        let urlString = "comgooglemaps://?q=\(lat),\(lng)&zoom=14"
        
        if let url = URL(string: urlString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // fallback to browser if Google Maps not installed
            let webURL = "https://maps.google.com/?q=\(lat),\(lng)"
            UIApplication.shared.open(URL(string: webURL)!)
        }
    }
    
    func getVendorsData() {
        let url = "\(hostName)\(EndPoints.vendorsList.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters:nil) { [weak self] (Model: BaseModel<TradersResponse>? , err : String? )in
          
            guard let self = self else { return }
            if Model?.status == "success" {
                vendorData = Model?.data
                state = .loaded(data: nil)
           } else {
               state = .error(err ?? "")
           }
            
        }
    }
    
    func handleFavourite(traderModel: Trader) {
        
        let url = "\(hostName)\(EndPoints.vendorDetails.rawValue)\(traderModel.id ?? 0)/favorite"
        
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .post, parameters: ["trader": "\(traderModel.id ?? 0)"]) { [weak self] (Model: BaseModel<IsFavouriteModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                if let index = vendorData?.data?.firstIndex(of: traderModel) {
                    vendorData?.data?[index].toggleFavourite()
                   
                }
            }else {
                self.state = .error(err ?? "")
            }
            
        }
    }
  
}
