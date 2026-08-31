import SwiftUI

struct NotificationsView: View {
  
    @ObservedObject private var viewModel: NotificationsViewModel
    init(viewModel: NotificationsViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        maincontent
            .background(
                Color(Color.backGroundColor)
            )
    }
    
    private var maincontent: some View {
        VStack {
            AppHeaderView(Title: "notifications") {
                viewModel.coordinator.disMiss()
            }
            ContentButtonView(title: "read_all_notifications".localized) {
                viewModel.markNotificationAsREad(notification_id: "")
            }
            .padding()
            ShowViewState(state: viewModel.state) { Model in
                notificationCard
            }
            
            
            Spacer()
        }
    }
    
    private var notificationCard: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.notifications) { notification in
                    NotificationCard(notification: notification)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentOrder: notification)
                        }
                        .onTapGesture {
                            handleNotification(type: notification.type ?? "", notifyId: "\(notification.notify_id ?? 0)")
                            viewModel.markNotificationAsREad(notification_id: "\(notification.id ?? "")")
                            
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func handleNotification(type: String, notifyId: String?) {
        if type == "new_order" || type == "new_offer" || type == "offer_accepted" || type == "rating_received" || type == "problem_reported" || type == "problem_resolved" || type == "problem_rejected" {
            viewModel.coordinator.showOrderDetails(orderId: notifyId ?? "")
        } else if type == "new_message" {
            viewModel.coordinator.showChatView(roomId: notifyId ?? "")
        }else if type == "payment_received" {
            viewModel.coordinator.showWallet()
        }
        
    }
}

struct NotificationCard: View {
    let notification: Notification

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                RemoteImageView(imageUrl: notification.icon ?? "")
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())

                Text(notification.title ?? "")
                    .font(addFont(fontType: .bold, size: 15))
                    .foregroundStyle(Color.MainColor)

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(notification.created_time ?? "")
                        .font(addFont(fontType: .Regular, size: 12))
                        .foregroundStyle(Color.CGray2)
                    Text(notification.created_at ?? "")
                        .font(addFont(fontType: .Regular, size: 12))
                        .foregroundStyle(Color.CGray2)
                }
            }

            Text(notification.body ?? "")
                .font(addFont(fontType: .Regular, size: 13))
                .foregroundStyle(Color.CBlack)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(notification.is_readed == true ? Color.CWhite : Color.MainColor.opacity(0.06))
        )
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

