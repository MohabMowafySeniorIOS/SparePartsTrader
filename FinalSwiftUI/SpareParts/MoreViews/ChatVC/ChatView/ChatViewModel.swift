//
//  ChatViewModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 7/5/25.
//

import Foundation
import Foundation
import Combine
import SwiftUI


class ChatViewModel: ObservableObject {

    @Published var messages: [messageModel] = []
    @Published var state: viewState<[messageModel]?> = .idle

    @ObservedObject var coordinator: MainCoordinator

    private let socketService = SocketService.shared

    var roomId: String
    var title: String
    private var currentPage = 1
    private var canLoadMore = true

    init(coordinator: MainCoordinator, roomId: String,title: String) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.roomId = roomId
        self.title = title
        connectSocket()
        getChats()
    }
    
   
}
extension ChatViewModel {
    func leaveChat() {
        socketService.leaveChat(chatId: Int(roomId) ?? 0)
    }
    
    func loadMoreIfNeeded(currentMessage: messageModel) {

        guard let first = messages.first else { return }

        if currentMessage.id == first.id  {
            getChats()
        }
    }
    
    func getChats(
        urlEndPoint: EndPoints = .chats,
        methodType: HTTPMethodType = .get
    ) {

        guard canLoadMore else { return }

        let url = "\(hostName)\(urlEndPoint.rawValue)/\(roomId)/messages?page=\(currentPage)"

        APIClient.shared.performRequestWithAlamofire(
            urlString: url,
            method: methodType,
            parameters: nil
        ) { [weak self] (Model: BaseModel<messageModelPaginate>?, err: String?) in

            guard let self else { return }

            if Model?.status == "success" {

                let newMessages = (Model?.data?.data ?? []).reversed()

                DispatchQueue.main.async {

                    self.messages.insert(contentsOf: newMessages, at: 0)

                    if self.currentPage < (Model?.data?.meta?.lastPage ?? 0) {
                        self.currentPage += 1
                       
                    } else {
                        self.canLoadMore = false
                    }
                }

            } else {
                self.state = .error(err ?? "")
            }
        }
    }
    func sendMessage(paramter: BaseParameters) {

        let url = "\(hostName)\(EndPoints.chats.rawValue)/\(roomId)/send"

        APIClient.shared.performRequestWithAlamofire(
            urlString: url,
            method: .post,
            parameters: paramter.toDictionary()
        ) { [weak self] (Model: BaseModel<messageModel>?, err: String?) in

            guard let self else { return }

            if Model?.status == "success" {

                if let message = Model?.data {

                    if !self.messages.contains(where: {$0.id == message.id}) {
                        self.messages.append(message)
                    }
                }

            } else {
                self.state = .error(err ?? "")
            }
        }
    }
}
private extension ChatViewModel {

    func connectSocket() {

        socketService.connect()

        socketService.joinChatRoom(chatId: roomId)

        socketService.listenMessages { [weak self] message in

            DispatchQueue.main.async {

                guard let self else { return }

                /// منع التكرار
                if !self.messages.contains(where: {$0.id == message.id}) {
                    self.messages.append(message)
                }
            }
        }
    }
}
