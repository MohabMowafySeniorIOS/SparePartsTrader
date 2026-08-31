import Foundation
import Combine
import SwiftUI

final class PhoneViewModel: ObservableObject {
    @Published var userData: LoginData?
    @Published var state: viewState<LoginData?> = .idle
    
    private let coordinator: AuthCoordinator
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
 
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func showOtp(phone:String) {
        print(phone)
        coordinator.showOTP(phone: phone, isForgetPass: true)
    }
    
    func fetchUsers(urlEndPoint:EndPoints, methodType: HTTPMethodType  ,parameters : BaseParameters) {
        let phone = parameters.toDictionary()["auth"] as? String
        print(phone,parameters.toDictionary())
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<LoginData>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.state = .loaded(data: Model?.data)
                userData = Model?.data
                AuthService.userData = Model?.data
                if Model?.data?.is_active == true {
                    self.coordinator.loginSuccess()
                }else {
                    
                    self.showOtp(phone: phone ?? "")
                }
               
            }else {
                state = .error(err ?? "")
            }
           
        }
    }
}

