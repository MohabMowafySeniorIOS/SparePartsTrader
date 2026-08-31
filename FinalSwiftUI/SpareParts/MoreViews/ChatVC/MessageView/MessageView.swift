//
//  MessageView.swift
//  FinalSwiftUI
//
//  Created by Mohab on 17/05/2025.
//

//import SwiftUI
//
//struct MessagesView: View {
//    @ObservedObject private var viewModel: MessagesViewModel
//    init(viewModel: MessagesViewModel) {
//        self._viewModel = ObservedObject(wrappedValue: viewModel)
//    }
//    var body: some View {
//        mainContetnt
//    }
//    
//    private var mainContetnt: some View {
//        VStack {
//            headerView
//            ShowViewState(state: viewModel.state) { Model in
//                listItem
//            }
//            Spacer()
//        }
//    }
//    
//    private var headerView: some View {
//        AppHeaderView(Title: "Messages".localized) {
//            viewModel.disMiss()
//        }
//    }
//    
//    private var listItem: some View {
//        List(viewModel.rooms,id: \.id) { room in
//            mchanelCard(room: room)
//                .onTapGesture {
//                    viewModel.coordinator.showChatView(roomId: "\(room.chatId ?? 0)")
//                }
//        }
//    }
//    
//    private func mchanelCard(room: MessagesModel) -> some View {
//        VStack(alignment: .leading) {
//            Text(room.last_message?.message ?? "")
//                .font(.headline)
//            Text(room.last_message?.message ?? "")
//                .font(.subheadline)
//                .foregroundColor(.gray)
////                Text(room.time ?? "")
////                    .font(.caption)
////                    .foregroundColor(.secondary)
//        }
//        .padding(.vertical, 4)
//    }
//}
//
