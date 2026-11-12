//
//  RootView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation
import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()
    @State private var restartID = UUID()

    var body: some View {
        Group {
            switch coordinator.flow {
            case .splash:
                SplashScreenView()
            case .language:
                LanguageSelectionView {
                    // Called only as a fallback; restart notification handles navigation.
                }
                .environmentObject(languageManager)
            case .auth:
                AuthCoordinatorView(appCoordinator: coordinator)
            case .main:
                MainCoordinatorView(appCoordinator: coordinator)
            case .onBoarding:
                OnBoardingView(appCoordinator: coordinator)
            }
        }
        .environmentObject(coordinator)
        .id(restartID)
        .onReceive(NotificationCenter.default.publisher(for: .restartAppForLanguage)) { _ in
            restartID = UUID()
            coordinator.languageSelected()
        }
        .onReceive(SessionEvents.shared.unauthorized) { _ in
            restartID = UUID()
        }
        .onReceive(NotificationCenter.default.publisher(for: FCMOrderNotificationRoute.notificationOpened)) { _ in
            if FCMOrderNotificationRoute.takePendingApprovalRefresh() {
                coordinator.refreshAccountApproval()
            }
        }
        .onAppear {
            coordinator.start()
            if FCMOrderNotificationRoute.takePendingApprovalRefresh() {
                coordinator.refreshAccountApproval()
            }
        }
    }
}
