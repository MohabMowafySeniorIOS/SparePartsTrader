//
//  VerificationModel.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 17/01/2025.
//

import Foundation
import Foundation
import Combine

import SwiftUI
class VerificationViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var activateModel: LoginData?
    @Published var resendCodeData: OTPData?
    @Published var isLoading: Bool?
    
   @ObservedObject var coordinator: AuthCoordinator
    
    init(coordinator: AuthCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    func ShowChangePassword(otp: String, phone: String){
        coordinator.showChangePassword(otp: otp, phone: phone)
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func VerifyAccount(urlEndPoint:EndPoints, methodType: HTTPMethodType  ,parameters : BaseParameters) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        isLoading = true
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<LoginData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                 guard let verifiedUser = Model?.data,
                       let token = verifiedUser.token,
                       !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                     self.errorMessage = err ?? "Unable to establish a secure session. Please try again."
                     self.isLoading = false
                     return
                 }
                 AuthService.userData = verifiedUser
                 DispatchQueue.main.async {
                     self.coordinator.openCompleteProfile(userModel: verifiedUser)
                 }
                
           }else {
            self.errorMessage = err
               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                  withAnimation {
                       self.errorMessage = nil
                   }
               }
           }
            self.isLoading = false
        }
    }
    
    
    func VerifyPassword(urlEndPoint:EndPoints = .password_verify, methodType: HTTPMethodType  ,parameters : BaseParameters) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        isLoading = true
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: parameters.toDictionary()) { [weak self] (Model: BaseModel<LoginData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                let phone = parameters.toDictionary()["auth"] as? String
                let code = parameters.toDictionary()["code"] as? String
                self.ShowChangePassword(otp: code ?? "", phone: phone ?? "")
           }else {
            self.errorMessage = err
               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                  withAnimation {
                       self.errorMessage = nil
                   }
               }
           }
            self.isLoading = false
        }
    }
    
    
    func ResendCode(urlEndPoint:EndPoints, methodType: HTTPMethodType,parameters : BaseParameters) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        isLoading = true
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters:parameters.toDictionary()) { [weak self] (Model: BaseModel<OTPData>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.resendCodeData = Model?.data
           }else {
            self.errorMessage = err
               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                  withAnimation {
                       self.errorMessage = nil
                   }
               }
           }
            self.isLoading = false
        }
    }
}

