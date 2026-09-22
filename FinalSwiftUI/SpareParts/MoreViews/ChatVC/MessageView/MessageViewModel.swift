//
//  MessageViewModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 7/5/25.
//

import Foundation
import Combine
import SwiftUI


class MessagesViewModel: ObservableObject {
    @Published var rooms: [MessagesModel] = []
    private var my_Id = "\(AuthService.userData?.id ?? "0")"
    @Published var state: viewState<[MessagesModel]?> = .idle
    @ObservedObject var coordinator: MainCoordinator
    var canLoadMore: Bool = false
    @Published var isLoadingMore: Bool = false
    private var currentPage = 1
    private var isLoading: Bool = false
    private var requestToken = 0
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        refresh()
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    // MARK: - Pagination
    func refresh() {
        requestToken += 1          // ignore any in-flight response of the old list
        currentPage = 1
        canLoadMore = false
        isLoading = false
        isLoadingMore = false
        getChats()
    }
    
    func loadMoreIfNeeded(currentRoom: MessagesModel) {
        guard let last = rooms.last else { return }
        if currentRoom.id == last.id && canLoadMore && !isLoading {
            getChats()
        }
    }

    func getChats(urlEndPoint:EndPoints = .chats, methodType: HTTPMethodType = .get ) {
        guard !isLoading else { return }
        let page = currentPage
        let token = requestToken
        let url = "\(hostName)\(urlEndPoint.rawValue)?page=\(page)"
        isLoading = true
        if page == 1 {
            state = .loading(loading: .progress)
        } else {
            isLoadingMore = true
        }
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters:nil) { [weak self] (Model: BaseModelPaginate<[MessagesModel]>? , err : String? )in
            guard let self = self, token == self.requestToken else { return }
            self.isLoading = false
            self.isLoadingMore = false
            if Model?.status == "success" {
                let newRooms = Model?.data?.data ?? []
                if page == 1 {
                    rooms = newRooms
                } else {
                    rooms.append(contentsOf: newRooms)
                }
                
                if page < (Model?.data?.lastPage ?? 0) {
                    currentPage = page + 1
                    canLoadMore = true
                } else {
                    canLoadMore = false
                }
               
                if rooms.count == 0 {
                    state = .emptyScreen
                }else {
                    state = .loaded(data: rooms)
                }
             }else {
                 state = .error(err ?? "")
             }
        }
    }
}
