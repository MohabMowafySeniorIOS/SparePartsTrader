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
    @Published var isLoadingMore: Bool = false
    var canLoadMore: Bool = false
    private var currentPage = 1
    private var isLoading: Bool = false
    var traderId = ""
    init(traderId: String) {
        self.traderId = traderId
        getRatings(traderId: traderId)
    }
    
    // MARK: - Pagination
    func loadMoreIfNeeded(currentRating: ratingData) {
        guard let last = ratings?.last else { return }
        if currentRating.id == last.id && canLoadMore && !isLoading {
            getRatings(traderId: traderId)
        }
    }
    
    func getRatings(urlEndPoint:EndPoints = .ratings, methodType: HTTPMethodType = .get, traderId: String) {
        guard !isLoading else { return }
        let page = currentPage
        let url = "\(hostName)\(urlEndPoint.rawValue)/\(traderId)?page=\(page)"
        isLoading = true
        if page == 1 {
            state = .loading(loading: .progress)
        } else {
            isLoadingMore = true
        }
        
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<RatingCard>? , err : String? )in
            guard let self = self else { return }
            self.isLoading = false
            self.isLoadingMore = false
             if Model?.status == "success" {
                 let newItems = Model?.data?.ratings?.data ?? []
                 if page == 1 {
                     self.ratings = newItems
                 } else {
                     self.ratings?.append(contentsOf: newItems)
                 }
                 
                 if page < (Model?.data?.ratings?.meta?.lastPage ?? 0) {
                     self.currentPage = page + 1
                     self.canLoadMore = true
                 } else {
                     self.canLoadMore = false
                 }
                 
                 self.state = .loaded(data: ratings)
                 if (self.ratings ?? []).isEmpty {
                     state = .emptyScreen
                 }
             }else {
                 self.state = .error(err ?? "")
             }
        }
    }
}


