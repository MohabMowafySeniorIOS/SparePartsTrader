//
//  AdditionalAddressDescribtionViewModel.swift
//  SpareParts
//
//  Created by Mohab on 26/01/2026.
//

import Foundation
import SwiftUI

class AdditionalAddressDescribtionViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isLoading: Bool?
   
    @Published var getCarCategory  = [categoryModel]()
    @Published var getCarBrand  = [categoryModel]()
    @Published var getCarModel  = [categoryModel]()
    @Published var getCarYears  = [Int]()
    @Published var addressModel:AddressData?
    
    var onDismiss: ()->Void
   
    init(addressModel:AddressData?,onDismiss: @escaping ()->Void ) {
        self.onDismiss = onDismiss
    }
    
    func disMiss(){
        onDismiss()
    }
    
    
    func AddAddressData(urlEndPoint:EndPoints = .client_addresses, methodType: HTTPMethodType = .post, paramter: BaseParameters) {
        var url = "\(hostName)\(urlEndPoint.rawValue)"
        var paramter = paramter
        if let carId = addressModel?.id  {
            url = "\(hostName)\(urlEndPoint.rawValue)/\(carId)"
            paramter.method = "PUT"
        }
        isLoading = true
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: paramter.toDictionary()) { [weak self] (Model: BaseModel<AddressData>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.disMiss()
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
