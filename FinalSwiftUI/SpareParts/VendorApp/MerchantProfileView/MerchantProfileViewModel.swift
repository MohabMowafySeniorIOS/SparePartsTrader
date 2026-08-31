//
//  VendorHomeViewModel.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//


import Foundation
import Combine
import SwiftUI

class MerchantProfileViewModel: ObservableObject {
    
    @Published var state: viewState<LoginData?> = .idle
    @Published var isFavourit: Bool?
    
    @ObservedObject var coordinator: MainCoordinator
    
    @Published var userModel: LoginData? = AuthService.userData
   
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        
    }
    
    func showUpdateFileBusniss(userModel: LoginData?){
        coordinator.showUpdateFileBusniss(userModel: userModel)
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
    
    func getProfileData() {
        print(EndPoints.profile.rawValue)
        let url = "\(hostName)trader/profile"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters:nil) { [weak self] (Model: BaseModel<LoginData>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                userModel = Model?.data
                self.state = .loaded(data: Model?.data)
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
        
       
}
