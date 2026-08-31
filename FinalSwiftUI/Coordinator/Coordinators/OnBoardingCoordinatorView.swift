//
//  AuthCoordinatorView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation
import SwiftUI

final class OnBoardingCoordinator: Coordinator {
   
    
  

    @Published var path = NavigationPath()
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    
    func finishOnboarding() {
        Helper.SaveisFirst(token: false)
        appCoordinator.flow = .auth
    }
    
    
 
    func pop() {
        print("")
    }
    
    func popToRoot() {
        print("")
    }
    
    func push(_ route: AppFlow) {
        print("")
    }
}
