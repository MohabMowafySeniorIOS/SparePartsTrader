//
//  ChatScreen.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//

import Foundation
import SwiftUI

import SwiftUI

struct chatView: View {
    
    @State private var messageText: String = ""
    @ObservedObject private var viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {

        VStack(spacing: 0) {

            headerView

            scrollView
        }
        .background(Color(.systemGroupedBackground))
        
        .safeAreaInset(edge: .bottom) {
            inputBar
                .background(.ultraThinMaterial)
        }

        .onDisappear {
            viewModel.leaveChat()
        }
    }
}
private extension chatView {
    
    var headerView: some View {
        AppHeaderView(Title: "Messages".localized) {
            viewModel.coordinator.disMiss()
        }
    }
}
private extension chatView {
    
    var scrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.messages, id: \.id) { message in
                        MessageRow(message: message)
                            .id(message.id)
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentMessage: message)
                            }
                    }
                }
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: viewModel.messages.last?.id) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onReceive(NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillShowNotification)) { _ in
                scrollToBottom(proxy: proxy)
            }

            .onReceive(NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillHideNotification)) { _ in
                    scrollToBottom(proxy: proxy)
            }
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastID = viewModel.messages.last?.id else { return }
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(lastID, anchor: .bottom)
            }
        }
    }
}
private extension chatView {
    
    var inputBar: some View {

        HStack {

            Button {
                send()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.MainColor)
                    .clipShape(Circle())
            }

            PlainUIKitTextField(
                text: $messageText,
                placeholder: "Write Here".localized
            )
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(Color.CWhite)
                .cornerRadius(22)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    func send() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        viewModel.sendMessage(paramter: .init(message: trimmed))
        messageText = ""
    }
}
struct MessageRow: View {
    
    let message: messageModel
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            
            if (message.sender?.name == AuthService.userData?.full_name) == true { Spacer() }
            
            if (message.sender?.name == AuthService.userData?.full_name) != true {
                RemoteImageView(imageUrl: message.sender?.avatar ?? "")
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
            
            VStack(alignment: message.sender?.name == AuthService.userData?.full_name ? .trailing : .leading, spacing: 6) {
                
                if (message.sender?.name == AuthService.userData?.full_name) != true {
                    Text(message.sender?.name ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(message.message ?? "")
                    .padding(12)
                    .background(
                        (message.sender?.name == AuthService.userData?.full_name) == true
                        ? Color.MainColor
                        : Color(.secondarySystemBackground)
                    )
                    .foregroundColor((message.sender?.name == AuthService.userData?.full_name) == true ? .white : .primary)
                    .cornerRadius(18)
                
                Text("\(message.created_date ?? "") \(message.created_at ?? "")")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if (message.sender?.name == AuthService.userData?.full_name) {
                RemoteImageView(imageUrl: message.sender?.avatar ?? "")
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
            
            if (message.sender?.name == AuthService.userData?.full_name) != true { Spacer() }
        }
    }
}
