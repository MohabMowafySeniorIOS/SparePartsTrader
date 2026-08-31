//
//  NotificationViewModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/15/25.
//

import Foundation
import SwiftUI

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    
    @Published var state: viewState<[Notification]?> = .idle
    var canLoadMore: Bool = false
    private var currentPage = 1
    @ObservedObject var coordinator: MainCoordinator
    
    
    init(coordinator: MainCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        fetchNotifications()
    }
    
    func loadMoreIfNeeded(currentOrder: Notification) {
        guard let last = notifications.last else { return }
        
        if (currentOrder.id == last.id) && canLoadMore {
            fetchNotifications()
        }
    }
    
    func fetchNotifications() {
        let url = "\(hostName)\(EndPoints.notifications.rawValue)?page=\(currentPage)"
        if currentPage == 1 {
            state = .loading(loading: .progress)
        }
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters: nil) { [weak self] (Model: NotificationModel? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.notifications.append(contentsOf: Model?.data ?? [])
                if currentPage == 1 {
                state = .loaded(data: nil)
                }
                if self.currentPage < (Model?.meta?.lastPage ?? 0) {
                    self.currentPage = self.currentPage + 1
                    self.canLoadMore = true
                }else {
        
                    self.canLoadMore = false
                }
               
                
                    if self.notifications.isEmpty {
                        state = .emptyScreen
                    }else {
                       
                    }
              
                
            }else {
                state = .error(err ?? "")
            }
        }
    }
    
    func markAllAsRead() {
        let url = "\(hostName)\(EndPoints.notifications.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters: nil) { [weak self] (Model: BaseModel<[Notification]>? , err : String? )in
            guard let self = self else { return }
            if let notifications = Model?.data {
                self.notifications = notifications
                if self.notifications.count > 0 {
                    self.state = .loaded(data: self.notifications)
                }else {
                    self.state = .emptyScreen
                }
            } else {
                self.state = .error(err ?? "")
            }
        }
    }
    
    func markNotificationAsREad(urlEndPoint:EndPoints = .notifications, methodType: HTTPMethodType = .post  ,notification_id : String) {
        let notificationId = (notification_id == "") ? "" : "/\(notification_id)"
        let url = "\(hostName)\(urlEndPoint.rawValue)\(notificationId)"
        state = .loading(loading: .progress)
        
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: ["_method": "PUT"]) { [weak self] (Model: BaseModel<String>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 
                 if self.notifications.count > 0 {
                     self.fetchNotifications()
                     self.state = .loaded(data: self.notifications)
                 }else {
                     self.state = .emptyScreen
                 }
             } else {
                 self.state = .error(err ?? "")
             }
        }
    }
    
    func getUnReadNotificationCount(urlEndPoint:EndPoints = .notifications, methodType: HTTPMethodType = .post  ,notification_id : String) {
        let url = "\(hostName)\(urlEndPoint.rawValue)\(notification_id)/read"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<UnreadNotificationsData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
               
                 if self.notifications.count > 0 {
                     self.state = .loaded(data: self.notifications ?? [])
                 }else {
                     self.state = .emptyScreen
                 }
             } else {
                 self.state = .error(err ?? "")
             }
        }
    }
}
