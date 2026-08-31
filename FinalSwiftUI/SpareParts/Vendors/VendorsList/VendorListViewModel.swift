//
//  VendorListViewModel.swift
//  SpareParts
//
//  Created by Mohab on 16/02/2026.
//

import Foundation
import SwiftUI
import Combine

class VendorListViewModel: ObservableObject {
    @Published var fieldText: String = ""
    @ObservedObject var locationManager: LocationManager
    @Published var filterObject: FilterObject = FilterObject()
    @Published  var countryAndCities: [CountryAndCitiesModel] = []
    @Published var vendorData: [Trader] = []
    @Published var state: viewState<BaseModel<String>> = .idle
    var canLoadMore: Bool = false
    private var currentPage = 1
    @ObservedObject var coordinator: MainCoordinator
    private var cancellables = Set<AnyCancellable>()

    init(coordinator: MainCoordinator, locationManager: LocationManager) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.locationManager = locationManager
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
        var countryId = ""
        var cityId = ""
        if !countryAndCities.isEmpty {
            countryId = "\(countryAndCities.last?.country?.id ?? 0)"
            if let cities = countryAndCities.last?.cities {
                if !cities.isEmpty {
                    cityId = "\(cities.last?.id ?? 0)"
                }
            }
        }
        var latitude = ""
        var longtiude = ""
        var rating = ""
        var orderBy = ""
        
        if let lat = locationManager.latitude,
           let lon = locationManager.longitude {
            latitude = "\(lat)"
            longtiude = "\(lon)"
           
        } else {
            print("Getting location...")
        }
        
        if latitude != "" {
//            if filterObject.isBest == true {
//                orderBy = "nearest"
//            }else {
//                orderBy = "nearest"
//            }
           
        }
        
        if rating != "" {
            if filterObject.isBest == true {
                rating = "5"
            }else {
                rating = "0"
            }
            
           // orderBy = "rating"
        }
        
        let url = "\(hostName)\(EndPoints.vendorsList.rawValue)?keyword=\(fieldText)&country_id=\(countryId)&city_id=\(cityId)&min_rating=\(rating)&order_by=\(orderBy)&latitude=\(latitude)&longitude=\(longtiude)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters:nil) { [weak self] (Model: BaseModel<TradersResponse>? , err : String? )in
            
            guard let self = self else { return }
            if Model?.status == "success" {
                vendorData = Model?.data?.data ?? []
                if vendorData.count > 0 {
                    state = .loaded(data: nil)
                }else {
                    state = .emptyScreen
                }
                
            } else {
                state = .error(err ?? "")
            }
            
        }
    }
    
    func handleFavourite(traderModel: Trader) {
        
        let url = "\(hostName)\(EndPoints.vendorDetails.rawValue)\(traderModel.id)/favorite"
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .post, parameters: ["trader": "\(traderModel.id)"]) { [weak self] (Model: BaseModel<IsFavouriteModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                DispatchQueue.main.async {
                    guard let index = self.vendorData.firstIndex(where: { $0.id == traderModel.id }) else { return }
                    self.vendorData[index].isFavorite.toggle()
                    self.vendorData = self.vendorData
                }
            }else {
                self.state = .error(err ?? "")
            }
            
        }
    }
    
}
