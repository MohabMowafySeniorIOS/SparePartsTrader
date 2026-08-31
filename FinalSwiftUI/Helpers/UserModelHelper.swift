//
//  UserModelHelper.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 12/01/2025.
//

import Foundation
import UIKit

typealias UserDataModel = LoginData

class AuthService {
    
    private init () { }
    
    private let userDataKey = "_User_|_Data_"
    private let packageExpireKey = "packageExpireKey"
    private static let userDefault = UserDefaults.standard
    
    fileprivate func getUserData() -> LoginData? {
        let defaults = UserDefaults.standard
        guard let savedPerson = defaults.object(forKey: userDataKey) as? Data,
              let loadedData = try? JSONDecoder().decode(UserDataModel.self, from: savedPerson)
        else { return nil }
        return loadedData
    }
    
    fileprivate func setUserData(_ newValue: LoginData?) {
        // guard let newValue = newValue else { return }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(newValue) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: userDataKey)
        } else {
            fatalError("Unable To Save User Data")
        }
    }
    
    static var userData: LoginData? {
        get {
            let authService = AuthService()
            return authService.getUserData()
        } set {
            let authService = AuthService()
            authService.setUserData(newValue)
        }
    }
    
    
}


