import Foundation
import Combine
import SwiftUI

final class OnBoardingViewModel: ObservableObject {
    
    private let coordinator: OnBoardingCoordinator
    
    init(coordinator: OnBoardingCoordinator) {
        self.coordinator = coordinator
    }
    
    func showAuth(){
        coordinator.finishOnboarding()
    }
  
}

