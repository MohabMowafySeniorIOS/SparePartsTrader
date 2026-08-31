//
//  AuthRoute.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/13/25.
//

import Foundation
enum AuthRoute: Hashable {
    case otp(phone:String,isForgetPass: Bool)
    case changePassword(otp: String, phone: String)
    case register
    case UpdateFileBusniss(userModel: LoginData?)
    case phone
    case verify(isForgetPass: Bool, phone: String)
}
