//
//  TotalCostViewModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//

import Foundation

import Foundation
import Combine

import SwiftUI
class TotalCostViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var viewModel  : String?
    @Published var isLoading: Bool?
    
    func getTotalCost(urlEndPoint:EndPoints, methodType: HTTPMethodType) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        isLoading = true
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<String>? , err : String? )in
            guard let self = self else { return }
             if err == nil {
                viewModel = Model?.data
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

