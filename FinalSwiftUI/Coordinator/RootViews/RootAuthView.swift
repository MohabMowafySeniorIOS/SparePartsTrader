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

            LoginVC(viewModel: LoginViewModel(coordinator: coordinator))
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
                        coordinator.showAddAddresses()
                    }, onDismiss: {
                        coordinator.path.removeLast(2)
                    }, onSuccess: {
                        coordinator.showWaitingForApproval()
                    }), userModel: userModel)
                        .navigationBarHidden(true)

                case .addAddress:
                    TraderAdditionalAddressDescribtionView(viewModel: AdditionalAddressDescribtionViewModel(addressModel: nil, onDismiss: {
                            coordinator.path.removeLast()
                        }))
                            .navigationBarHidden(true)

                case .waitingForApproval:
                    TraderWaitingForApprovalView {
                        coordinator.returnToLogin()
                    }
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

private struct TraderWaitingForApprovalView: View {
    let onReturnToLogin: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 32)

            Image(systemName: "clock.badge.checkmark")
                .font(.system(size: 66, weight: .regular))
                .foregroundStyle(Color.MainColor)
                .frame(width: 144, height: 144)
                .background(Color.MainColor.opacity(0.10), in: Circle())
                .accessibilityHidden(true)

            Text("trader_approval_title".localized)
                .font(addFont(fontType: .bold, size: 24))
                .foregroundStyle(Color.TitleColor)
                .multilineTextAlignment(.center)
                .padding(.top, 32)

            Text("trader_approval_message".localized)
                .font(addFont(fontType: .Regular, size: 17))
                .foregroundStyle(Color.CGray1)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 30)
                .padding(.top, 12)

            Spacer()

            ContentButtonView(title: "trader_approval_back_to_login".localized, action: onReturnToLogin)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGroundColor.ignoresSafeArea())
    }
}
