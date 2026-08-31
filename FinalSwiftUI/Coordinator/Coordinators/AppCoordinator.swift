//
//  AppCoordinator.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/12/25.
//

import Foundation
import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var flow: AppFlow = .splash
    
   @MainActor func start() {
        
        bindUnauthorized()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.checkAuth()
        }
            
    }
    
    func checkAuth() {
        // 1. First ever launch → show language selection
        guard Helper.getHasSelectedLanguage() else {
            flow = .language
            return
        }

        // 2. Language chosen before → check onboarding
        if Helper.getisFirst() == false {
            let isLoggedIn = ((AuthService.userData?.token?.count ?? 0) > 0)
            flow = isLoggedIn ? .main : .auth
        } else {
            flow = .onBoarding
        }
    }
    
    /// Called by LanguageSelectionView after the user confirms a language.
    func languageSelected() {
        // After language is picked, show onboarding (first time) or auth
        if Helper.getisFirst() == false {
            let isLoggedIn = ((AuthService.userData?.token?.count ?? 0) > 0)
            flow = isLoggedIn ? .main : .auth
        } else {
            flow = .onBoarding
        }
    }
}
@MainActor
extension AppCoordinator {

    func bindUnauthorized() {
        SessionEvents.shared.unauthorized
            .sink { [weak self] in
                self?.checkAuth()
            }
            .store(in: &cancellables)
    }
}
