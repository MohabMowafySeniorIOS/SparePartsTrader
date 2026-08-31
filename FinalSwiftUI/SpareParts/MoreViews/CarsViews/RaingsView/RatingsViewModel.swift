//
//  RatingsViewModel.swift
//  MyAuctions
//
//  Created by Mohab on 07/07/2025.
//
import Foundation
import Combine

import SwiftUI

class RatingViewModel: ObservableObject {
   
    @Published var ratings: [ratingData]?
    @Published var state: viewState<[ratingData]?> = .idle
    var traderId = ""
    init(traderId: String) {
        self.traderId = traderId
        getRatings(traderId: traderId)
    }
    
    func getRatings(urlEndPoint:EndPoints = .ratings, methodType: HTTPMethodType = .get, traderId: String) {
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(traderId)"
        state = .loading(loading: .progress)
        
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<RatingCard>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 self.ratings = Model?.data?.ratings?.data ?? []
                 self.state = .loaded(data: ratings)
                 if self.ratings?.count == 0 {
                     state = .emptyScreen
                 }
             }else {
                 self.state = .error(err ?? "")
             }
        }
    }
}


