import Foundation
import Combine
import SwiftUI

final class LoginViewModel: ObservableObject {
    
    @Published var state: viewState<LoginData?> = .idle
    
    private let coordinator: AuthCoordinator
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    
    func showRegister() {
        coordinator.showRegister()
    }
    
    func showGuest() {
        guard let user = AuthService.userData else {
            coordinator.loginSuccess()
            return
        }

        if user.is_profile_complate == false {
            coordinator.openCompleteProfile(userModel: user)
        } else if user.trader?.isApproved != true {
            coordinator.showWaitingForApproval()
        } else {
            coordinator.loginSuccess()
        }
    }
    
    func showOtp(phone:String,isForgetPass: Bool) {
        print(phone)
        coordinator.showOTP(phone: phone, isForgetPass: isForgetPass)
    }
    
    func showPhone() {
        
        coordinator.showPhoneScreen()
    }
    
    func fetchUsers(urlEndPoint:EndPoints, methodType: HTTPMethodType  ,parameters : BaseParameters) {
        let phone = parameters.toDictionary()["auth"] as? String
        print(phone,parameters.toDictionary())
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<LoginData>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                state = .loaded(data: Model?.data)
                AuthService.userData = Model?.data
                if Model?.data?.is_active == true {
                    if Model?.data?.is_profile_complate == false {
                        self.coordinator.openCompleteProfile(userModel: Model?.data)
                    } else if Model?.data?.trader?.isApproved != true {
                        self.coordinator.showWaitingForApproval()
                    } else {
                        self.coordinator.loginSuccess()
                    }
                }else {
                    
                    self.showOtp(phone: phone ?? "" , isForgetPass: false)
                }
               
            }else {
                state = .error(err ?? "")
            }
        }
    }
}

