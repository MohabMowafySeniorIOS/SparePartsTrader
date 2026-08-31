//
//  RootAuthView.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation
import SwiftUI
struct OnBoardingView: View {

    @StateObject private var coordinator: OnBoardingCoordinator

    init(appCoordinator: AppCoordinator) {
        _coordinator = StateObject(
            wrappedValue: OnBoardingCoordinator(appCoordinator: appCoordinator)
        )
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            // Create a viewModel using the coordinator and pass it to OnboardingView
            OnboardingView(viewModel: OnBoardingViewModel(coordinator: coordinator))
                .navigationBarHidden(true)
        }
    }
}
