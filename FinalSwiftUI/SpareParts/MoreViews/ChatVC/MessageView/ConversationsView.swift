//
//  ConversationsView.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//

import Foundation
import SwiftUI
struct MessagesView: View {
    
    @ObservedObject private var viewModel: MessagesViewModel
    init(viewModel: MessagesViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            headerView
            scrollView
            Spacer()
        }.background(
                Color(Color.backGroundColor)
            )

    }
    
    private var scrollView: some View {
        ShowViewState(state: viewModel.state) { Model in
            ScrollView {
                VStack(spacing: 15) {
                   
                    ForEach(viewModel.rooms, id: \.id) { conversation in
                        ConversationRow(conversation: conversation).onTapGesture {
                            viewModel.coordinator.showChatView(roomId: "\(conversation.chatId ?? 0)", title: "\(conversation.other_party?.name ?? "")-\(conversation.order?.orderNumber ?? "")")
                        }
                    }
                    Spacer()
                }
                .padding(.top)
            }
        }
        
    }
    
    private var headerView: some View {
          AppHeaderView(Title: "Messages".localized) {
              viewModel.disMiss()
          }
      }
}
struct ConversationRow: View {
    let conversation: MessagesModel
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Avatar
            RemoteImageView(imageUrl: conversation.other_party?.avatar ?? "")
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            
            VStack(alignment: .trailing, spacing: 6) {
                
                HStack {
                    Text("\(conversation.other_party?.name ?? "")-\(conversation.order?.orderNumber ?? "")")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(conversation.last_message?.message ?? "")
                        .font(.headline)
                }
                
                HStack {
                    Text(conversation.last_message?.created_at ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .fontWeight(.bold)
                   
                    
                    Spacer()
                    
                    if (conversation.unread_count ?? 0) > 0 {
                        Text("\(conversation.unread_count ?? 0)")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                   
                }
            }
        }
        .padding()
        .background(Color.CWhite)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        .padding(.horizontal)
    }
}
