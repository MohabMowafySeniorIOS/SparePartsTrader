//
//  HelperClass.swift
//  MVP
//
//  Created by Mohab on 7/18/21.
//

import Foundation
import Foundation

import UIKit

class Helper: NSObject {
    
   
    
    // IsFirst
    
    class func isFirst()->String {
        
        let api_token = "isFirst"
        return api_token
    }
    
    class func SaveisFirst(token : Bool?){
        let def = UserDefaults.standard
        def.setValue(token, forKey: isFirst())
        def.synchronize()
    }
    
    class func getisFirst()->Bool? {
        let def = UserDefaults.standard
        return def.object(forKey: isFirst()) as? Bool
    }
    
    
    // IsFirst
    
    class func isCountry()->String {
        
        let api_token = "isCountry"
        return api_token
    }
    
    class func SaveisCountry(token : String?){
        let def = UserDefaults.standard
        def.setValue(token, forKey: isCountry())
        def.synchronize()
    }
    
    class func getisCountry()->String? {
        let def = UserDefaults.standard
        return def.object(forKey: isCountry()) as? String
    }
    
    // IsFirst
    
    class func isStart_Language()->String {
        
        let api_token = "isStart_Language"
        return api_token
    }
    
    class func SaveisStart_Language(token : String?){
        let def = UserDefaults.standard
        def.setValue(token, forKey: isStart_Language())
        def.synchronize()
    }
    
    class func getisStart_Language()->String? {
        let def = UserDefaults.standard
        return def.object(forKey: isStart_Language()) as? String
    }
    
    
    // IsFirst
    
    class func isStart_screen()->String {
        
        let api_token = "isStart_screen"
        return api_token
    }
    
    class func SaveisStart_screen(token : String?){
        let def = UserDefaults.standard
        def.setValue(token, forKey: isStart_screen())
        def.synchronize()
    }
    
    class func getisStart_screen()->String? {
        let def = UserDefaults.standard
        return def.object(forKey: isStart_screen()) as? String
    }
    
    // IsFirst
    
    class func isComplete_Register()->String {
        
        let api_token = "isComplete_Register"
        return api_token
    }
    
    class func SaveisComplete_Register(token : String?){
        let def = UserDefaults.standard
        def.setValue(token, forKey: isComplete_Register())
        def.synchronize()
    }
    
    class func getisComplete_Register()->String? {
        let def = UserDefaults.standard
        return def.object(forKey: isComplete_Register()) as? String
    }

  
    
    class func Fcm_toket()->String {
        let Fcm_token = "Fcmtoken"
        return Fcm_token
    }
    
    class func SaveFcmtoken(Fcmtoken : String?){
        let def = UserDefaults.standard
        def.setValue(Fcmtoken, forKey: Fcm_toket())
        def.synchronize()
    }
    
    class func getFcmtoken()->String? {
        let def = UserDefaults.standard
        return def.object(forKey: Fcm_toket()) as? String
    }
    
    
    
    class func User_Provider()->String {
        let user_provider = "userprovider"
        return user_provider
    }
    
    class func SaveUser_Provider(user_provider : String?){
        
        let def = UserDefaults.standard
        def.setValue(user_provider, forKey: User_Provider())
        def.synchronize()
    }
    
   
    
   
}
// MARK: - Language Selection (added for LanguageSelectionView)
extension Helper {
    class func hasSelectedLanguageKey() -> String { "hasSelectedLanguage" }

    class func SavehasSelectedLanguage(value: Bool) {
        UserDefaults.standard.set(value, forKey: hasSelectedLanguageKey())
        UserDefaults.standard.synchronize()
    }

    class func getHasSelectedLanguage() -> Bool {
        UserDefaults.standard.bool(forKey: hasSelectedLanguageKey())
    }
}
