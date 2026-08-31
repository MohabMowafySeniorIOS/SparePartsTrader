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
                    // Called only as a fallback; restart notification handles navigation
                }
                .environmentObject(languageManager)

            case .auth:
                AuthCoordinatorView(appCoordinator: coordinator)

            case .main:
                MainCoordinatorView(appCoordinator: coordinator)
           
            case .onBoarding:
                OnBoardingView(appCoordinator: coordinator)
            }
        }  .environmentObject(coordinator)
            .id(restartID)   // 🔥 ده اللي بيعمل restart فعلي
        
        // ── Restart triggered by language selection ──────────────────────
        .onReceive(NotificationCenter.default.publisher(for: .restartAppForLanguage)) { _ in
            // Rebuild entire view tree with new layout direction
            restartID = UUID()
            // After rebuild, checkAuth will route to onBoarding or auth
            coordinator.languageSelected()
        }
        // ── Restart triggered by session expiry ──────────────────────────
        .onReceive(SessionEvents.shared.unauthorized) { _ in
            restartID = UUID()
        }
        
        .onAppear {
            coordinator.start()
        }
    }
}
