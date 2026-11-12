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
    private var isRefreshingTraderSession = false
    
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
            guard let user = AuthService.userData,
                  let token = user.token,
                  !token.isEmpty else {
                flow = .auth
                return
            }
            refreshTraderSession(cachedUser: user)
        } else {
            flow = .onBoarding
        }
    }
    
    /// Called by LanguageSelectionView after the user confirms a language.
    func languageSelected() {
        // After language is picked, show onboarding (first time) or auth
        if Helper.getisFirst() == false {
            checkAuth()
        } else {
            flow = .onBoarding
        }
    }

    private func refreshTraderSession(cachedUser: LoginData) {
        guard !isRefreshingTraderSession else { return }
        isRefreshingTraderSession = true

        let url = "\(hostName)trader/profile"
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: .get, parameters: nil) { [weak self] (model: BaseModel<LoginData>?, _) in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isRefreshingTraderSession = false

                if model?.status == "success", var refreshedUser = model?.data {
                    if refreshedUser.token == nil || refreshedUser.token?.isEmpty == true {
                        refreshedUser.token = cachedUser.token
                    }
                    AuthService.userData = refreshedUser
                    self.routeAuthenticatedUser(refreshedUser)
                } else {
                    self.routeAuthenticatedUser(cachedUser)
                }
            }
        }
    }

    func refreshAccountApproval() {
        guard let user = AuthService.userData, let token = user.token, !token.isEmpty else {
            flow = .auth
            return
        }
        refreshTraderSession(cachedUser: user)
    }

    private func routeAuthenticatedUser(_ user: LoginData) {
        guard let token = user.token, !token.isEmpty else {
            flow = .auth
            return
        }

        if user.is_profile_complate == false {
            flow = .auth
        } else if user.trader?.isApproved == true {
            flow = .main
        } else {
            // LoginVC detects the retained token and opens the approval screen.
            flow = .auth
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
