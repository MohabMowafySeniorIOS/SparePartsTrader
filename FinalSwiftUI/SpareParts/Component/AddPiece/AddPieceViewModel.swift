//
//  AddPieceViewؤخيثم.swift
//  SpareParts
//
//  Created by Mohab on 14/02/2026.
//

import Foundation
import Combine
import SwiftUI

class AddPieceViewModel: ObservableObject {
    
    @Published var state: viewState<HomeResponse?> = .idle
    @Published var isFavourit: Bool?
    
   
   
   
    
    func completeProfile(parameters:BaseParameters) {
        let url = "\(hostName)\(EndPoints.completeProfile.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .post, parameters:parameters.toDictionary()) { [weak self] (Model: BaseModel<HomeResponse>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.state = .loaded(data: Model?.data)
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
        
       
}
