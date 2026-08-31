//
//  RootAuthView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation
import SwiftUI
struct AuthCoordinatorView: View {

    @StateObject private var coordinator: AuthCoordinator

    init(appCoordinator: AppCoordinator) {
        _coordinator = StateObject(
            wrappedValue: AuthCoordinator(appCoordinator: appCoordinator)
        )
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {

            LoginVC(
                viewModel: LoginViewModel(coordinator: coordinator)
            )
            .navigationBarHidden(true)
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .otp(let phone,let isForgetPass):
                    OTPView(phone: phone, isForgetPass: isForgetPass, viewModel: VerificationViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .changePassword(let otp, let phone):
                    ChangePasswordView(viewModel: ChangePasswordViewModel(coordinator: coordinator), otp: otp, phone: phone)
                        .navigationBarHidden(true)
                case .register:
                    RegisterVC(viewModel: RegisterViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)

                case .verify(let isForgetPass, let phone):
                    RegisterVC(viewModel: RegisterViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                case .phone:
                    PhoneView(viewModel: PhoneViewModel(coordinator: coordinator))
                        .navigationBarHidden(true)
                    
                case .UpdateFileBusniss(userModel: let userModel):
                    AddMerchantView(viewModel: AddMerchantViewModel(onAddress: {
                        AdditionalAddressDescribtionView(viewModel: AdditionalAddressDescribtionViewModel(addressModel: nil, onDismiss: {
                            coordinator.path.removeLast()
                        }))
                            .navigationBarHidden(true)
                    }, onDismiss: {
                        coordinator.path.removeLast(2)
                    }, onSuccess: {
                        coordinator.path.removeLast(2)
                    }), userModel: userModel)
                        .navigationBarHidden(true)
                    
                }
            }
        }
    }
}
