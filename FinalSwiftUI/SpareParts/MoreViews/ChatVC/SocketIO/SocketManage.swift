//
//  SocketManage.swift
//  SpareParts
//
//  Created by Mohab on 12/03/2026.
//

import Foundation
import SocketIO

final class SocketService {

    static let shared = SocketService()

    private var manager: SocketManager!
    private var socket: SocketIOClient!

    private init() {

        manager = SocketManager(
            socketURL: URL(string: "https://drivak.com.sa:4001")!,
            config: [
                .log(true),
                .compress,
                .forceWebsockets(true)
            ]
        )

        socket = manager.defaultSocket
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }
    
    func joinChatUpdateRoom(clientId: String) {

        socket.emit("join-chat-update-room", [
            "clientId": clientId
        ])
    }
    
    func joinChatRoom(chatId: String) {

        socket.emit("join-chat-room", [
            "chatId": chatId
        ])
    }
    
    func leaveChat(chatId: Int) {

        socket.emit("leave-room", [
            "roomName": "chat:\(chatId)"
        ])
    }
    
    func listenMessages(completion: @escaping (messageModel) -> Void) {

        socket.on("chat_message") { data, ack in

            guard let dict = data.first as? [String: Any],
                  let messageData = dict["message"] as? [String: Any]
            else { return }

            do {

                let jsonData = try JSONSerialization.data(withJSONObject: messageData)

                let message = try JSONDecoder().decode(messageModel.self, from: jsonData)

                completion(message)

            } catch {
                print(error)
            }
        }
    }
    
}
