//
//  NetWorkHelper.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 12/01/2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case serverError(String)
    case decodingError
    case NotAuthorized
    case ParamterError
}

public enum HTTPMethodType: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
public enum EndPoints: String {
    
    //MARK: AUTH
    case register =  "trader/auth/register"
    case Login = "trader/auth/login"
    case verify_phone = "trader/auth/verify"
    case resend_otp = "trader/auth/send"
    case forgot_password = "trader/password/forget"
    case password_verify = "trader/password/verify"
    case reset_password = "trader/password/reset"
    case update_password = "trader/profile/update-password"
    case logout = "trader/logout"
    
    //MARK: Profile
    case updatePhone = "trader/profile/send/otp"
    case activeUpdatePhone = "trader/profile/update/auth"
    
    //    MARK: Home
    case home = "trader/home"
    case vendorsList = "trader/traders"
    case favorites = "trader/traders/favorites/list"
    case vendorDetails = "trader/traders/"
    case orders = "trader/orders"
    
    //MARK: Chats
    case chats = "trader/chats"
    case unread_count = "trader/chats/unread-count"
    
    //MARK: Payment
    case AvailablePaymentMethod = "trader/payment-methods"
    case Wallet = "trader/wallet"
    case WalletBalanace = "trader/wallet/balance"
    case WalletTransAction = "trader/wallet/transactions"
    case ChargeWallet = "trader/wallet/charge"
    case WalletChanges = "trader/wallet/charges"
    case WalletWithDraw = "trader/wallet/withdraw"
    case WalletWithDrawRequest = "trader/wallet/withdraw-requests"
    
    
    //MARK: Car Properties
    case categories = "trader/cars/categories"
    case brands = "trader/cars/brands"
    case Models = "trader/cars/models"
    case years = "trader/cars/years"
    //MARK: General
    
    //MARK: UserProfile
    case profile = "trader/profile"
    case account_request_deletion = "trader/profile/delete/account"
    
    //MARK: SidMenue Views
    
    //MARK: Addresses
    case client_addresses = "trader/addresses"
    //MARK: Cars
    case profile_cars = "trader/vehicles"
    
    
    //MARK: Vendor
    
    case completeProfile = "trader/profile/complete"
    
    
    case ratings = "trader/ratings/trader"
    
    
    
    //MARK: AttachMents
    case storeAttachMents = "general/attachment"
    case getAttachMents = "general/attachment/models/list"
    case deleteAttachMent = "general/attachment/delete"
    
    //MARK: General
    case countries = "general/countries"
    case cities = "general/cities"
    case settings = "general/settings"
    
    //MARK: Pages
    case pages = "general/pages/pages"
    case faq = "general/pages/faqs"
    case showPage = "general/pages/page"
    case contact_us = "general/pages/contact"
    
   
    
    
    // MARK: Notifications
    case notifications = "general/notifications"
    
    

    
    //MARK: General Categories
    case general_categories = "general-categories"
    
    
    //MARK: Settings&Contents
    case settings_public = "settings"
    
    //MARK: Settings&Merchant
    case statistics = "trader/dashboard/stats"
    case toggleReceivingOrder = "trader/profile/toggle-receiving-orders"
  
    
    
    
}
extension EndPoints {
    var path: String {
        rawValue.replacingOccurrences(of: "client", with: userType)
    }
}
