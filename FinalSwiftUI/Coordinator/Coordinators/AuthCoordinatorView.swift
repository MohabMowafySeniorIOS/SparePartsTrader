//
//  AuthCoordinatorView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation
import SwiftUI

final class AuthCoordinator: Coordinator {
    func push(_ route: AppFlow) {
        
    }
    
  

    @Published var path = NavigationPath()
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func openCompleteProfile(userModel: LoginData?) {
        path.append(AuthRoute.UpdateFileBusniss(userModel: userModel))
    }
    
    func showRegister() {
        path.append(AuthRoute.register)
    }
    
    func loginSuccess() {
        appCoordinator.flow = .main
    }
    
    func showPhoneScreen() {
        path.append(AuthRoute.phone)
    }


    func showOTP(phone: String,isForgetPass: Bool) {
        path.append(AuthRoute.otp(phone: phone, isForgetPass: isForgetPass))
    }

  
    
    func showChangePassword(otp: String, phone: String) {
        path.append(AuthRoute.changePassword(otp: otp, phone: phone))
    }
    
    func showVerify(isForgetPass: Bool, phone: String){
        path.append(AuthRoute.verify(isForgetPass: isForgetPass, phone: phone))
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count-1)
    }
    
}
