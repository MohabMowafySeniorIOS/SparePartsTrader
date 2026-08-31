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
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        getChats()
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }

    func getChats(urlEndPoint:EndPoints = .chats, methodType: HTTPMethodType = .get ) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters:nil) { [weak self] (Model: BaseModelPaginate<[MessagesModel]>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                 rooms = Model?.data?.data ?? []
               
                if rooms.count == 0 {
                    state = .emptyScreen
                }else {
                    state = .loaded(data: Model?.data?.data ?? [])
                }
             }else {
                 state = .error(err ?? "")
             }
        }
    }
}
