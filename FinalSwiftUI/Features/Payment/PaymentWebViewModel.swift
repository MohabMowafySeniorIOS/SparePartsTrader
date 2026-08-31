//
//  PaymentWebView.swift
//  SpareParts
//
//  Created by Mohab on 20/02/2026.
//

import Foundation
import Combine
import SwiftUI

final class PaymentWebViewModel: ObservableObject {
    
    @Published var state: viewState<LoginData?> = .idle
    
    let coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    func paymentSuccess(){
        coordinator.path.removeLast(coordinator.path.count-1)
    }
    
   
}

