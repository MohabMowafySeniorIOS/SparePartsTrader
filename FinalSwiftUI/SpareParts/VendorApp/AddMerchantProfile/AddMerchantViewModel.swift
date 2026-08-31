//
//  AddMerchantViewModel.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//

import Foundation
import Foundation
import Combine
import SwiftUI

enum imageType {
    case logoAttachMent
    case image1AttachMent
    case image2AttachMent
    case image3AttachMent
    case commercialAttachMent
}

class AddMerchantViewModel: ObservableObject {
    
    let onAddress: () -> Void
    let onDismiss: () -> Void
    let onSuccess: () -> Void
    
    @Published var myAddresses = [AddressData]()
    @Published var selectedAddresses: AddressData? = nil
    
    @Published var state: viewState<HomeResponse?> = .idle
    @Published var isFavourit: Bool?
    
    @Published var countryArray = [CountryData]()
    @Published var cityArray = [CityData]()
    @Published var selectedCcountry: CountryData? = nil
    @Published var selectedCity: CityData? = nil
    
    
    @Published var logoAttachMent: Logo?
    @Published var image1AttachMent: Logo?
    @Published var image2AttachMent: Logo?
    @Published var image3AttachMent: Logo?
    @Published var commercialAttachMent: Logo?
    
   
    
    init(onAddress: @escaping () -> Void,onDismiss: @escaping () -> Void,onSuccess: @escaping () -> Void) {
        self.onAddress = onAddress
        self.onDismiss = onDismiss
        self.onSuccess = onSuccess
      
        fetchCountries()
        fetchCities()
        getAddressAgenda()
    }
    

    
    func fetchCountries(urlEndPoint:EndPoints = .countries, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[CountryData]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.countryArray = Model?.data ?? []
                 countryArray.map { item in
                     if item.id == AuthService.userData?.trader?.country?.id {
                         self.selectedCcountry = item
                     }
                 }
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
                 cityArray.map { item in
                     if item.id == AuthService.userData?.trader?.city?.id {
                         self.selectedCity = item
                     }
                 }
             }else {
                 state = .error(err ?? "")
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
    
    func completeProfile(parameters:BaseParameters) {
        let url = "\(hostName)\(EndPoints.completeProfile.rawValue)"
        state = .loading(loading: .progress)
        print(parameters.toDictionary())
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .post, parameters:parameters.toDictionary()) { [weak self] (Model: BaseModel<HomeResponse>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.state = .loaded(data: Model?.data)
                self.onSuccess()
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
    
    func destoryAttach(id:String,completion: @escaping () -> Void ) {
        let url = "\(hostName)general/attachment/delete/\(id)"
        state = .loading(loading: .progress)
        
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .post, parameters:nil) { [weak self] (Model: BaseModel<HomeResponse>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.state = .loaded(data: Model?.data)
                completion()
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
        
    func LogoAttachMent(urlEndPoint:EndPoints = .storeAttachMents,file: UIImage?, methodType: HTTPMethodType = .post ,parameters : BaseParameters,imageType: imageType) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        
        state = .loading(loading: .progress)
        APIClient.shared.uploadMultipartWithAlamofire(urlString: url,file: file, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<Logo>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 switch imageType {
                     
                 case .logoAttachMent:
                     logoAttachMent = Model?.data
                 case .image1AttachMent:
                     image1AttachMent = Model?.data
                 case .image2AttachMent:
                     image2AttachMent = Model?.data
                 case .image3AttachMent:
                     image3AttachMent = Model?.data
                 case .commercialAttachMent:
                     commercialAttachMent = Model?.data
                 }
                
                 state = .loaded(data: state.data)
            }else {
                state = .error(err ?? "")
            }
        }
    }
       
}
