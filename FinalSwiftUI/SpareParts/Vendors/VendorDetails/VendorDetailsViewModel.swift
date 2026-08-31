//
//  VendorDetailsViewModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import Foundation
import Combine
import Alamofire
import SwiftUI
class VendorDetailsViewModel: ObservableObject {
   
    @Published var vendorModel: Trader?
    @Published var state: viewState<BaseModel<String>> = .idle
    
    @ObservedObject var coordinator: MainCoordinator
    var vendorId: String
    init(coordinator: MainCoordinator,vendorId: String) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.vendorId = vendorId
        getVendorDetails(vendorId: vendorId)
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
    
    func getVendorDetails(vendorId: String, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(EndPoints.vendorDetails.rawValue)\(vendorId)"
        print(url)
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<Trader>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                vendorModel = Model?.data
                state = .loaded(data: nil)
            }else {
                state = .error(err ?? "")
            }
           
        }
    }
    
    func handleFavourite(vendorId: String) {
        
        let url = "\(hostName)\(EndPoints.vendorDetails.rawValue)\(vendorId)/favorite"
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .post, parameters: ["trader": "\(vendorId)"]) { [weak self] (Model: BaseModel<IsFavouriteModel>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                DispatchQueue.main.async {
                    self.vendorModel?.isFavorite.toggle()
                }
            }else {
                self.state = .error(err ?? "")
            }
            
        }
    }
}

