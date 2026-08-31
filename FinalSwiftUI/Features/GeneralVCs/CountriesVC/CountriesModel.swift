//
//  CountriesModel.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 16/01/2025.
//

import Foundation
import Foundation
import Combine

import SwiftUI
class CountriesViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var CountriesData: [CountriesData]?
    @Published var isLoading: Bool?
    
    func fetchUsers(urlEndPoint:EndPoints, methodType: HTTPMethodType) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        isLoading = true
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[CountriesData]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.CountriesData = Model?.data
           }else {
            self.errorMessage = err
               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                  withAnimation {
                       self.errorMessage = nil
                   }
               }
           }
            self.isLoading = false
        }
    }
}
