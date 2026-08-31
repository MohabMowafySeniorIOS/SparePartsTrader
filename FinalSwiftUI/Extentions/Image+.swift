//
//  Image+.swift
//  FinalSwiftUI
//
//  Created by Mohab on 16/05/2025.
//

import Foundation
import SwiftUI

enum AssetImage {
    // MARK: Language Assets
    static let arabLang = "arabLang"
    static let enLang = "enLang"
    static let globalIcon = "globalIcon"
    static let languageLogo = "languageLogo"
    static let selectIcon = "selectIcon"
    static let unSelectICon = "unSelectICon"
    
    // MARK: On Boarding Assets
    static let onboarding1_1 = "onboarding1 1"
    static let onboarding1 = "onboarding1"
    static let onboarding2_1 = "onboarding2 1"
    static let onboarding2 = "onboarding2"
    static let onboarding3_1 = "onboarding3 1"
    static let onboarding3 = "onboarding3"
    
    
    // MARK: Notification Assets
    
    static let notificationIcon = "notificationIcon"
    
    // MARK: Login
    static let notEyeIcon = "notEyeIcon"
    
    // MARK: Register
    static let CamerICon = "CamerICon"
    static let checkedIcon = "checkedIcon"
    static let unCheckedIcon = "unCheckedIcon"
    
    // MARK: SidMEnueVC
    static let profileImage = "portrait-white-man-isolated"
    
    // MARK: General
    static let RightArrow = "RightArrow"
    
    // MARK: AuctionVC
    static let FavouriteBtn = "FavouriteBtn"
    static let unFavouriteIcon = "unFavouriteIcon"
    static let carImage = "carImage"
    
    //MARK: Splash VC
    static let Splashlogo = "Splashlogo"
}


extension Image {
    // MARK: Language Assets
    static let arabLang = Image(AssetImage.arabLang)
    static let enLang = Image(AssetImage.enLang)
    static let globalIcon = Image(AssetImage.globalIcon)
    static let languageLogo = Image(AssetImage.languageLogo)
    static let Splashlogo = Image(AssetImage.Splashlogo)
    static let selectIcon = Image(AssetImage.selectIcon)
    static let unSelectICon = Image(AssetImage.unSelectICon)
    
    // MARK: On Boarding Assets
    static let onboarding1_1 = Image(AssetImage.onboarding1_1)
    static let onboarding1 = Image(AssetImage.onboarding1)
    static let onboarding2_1 = Image(AssetImage.onboarding2_1)
    static let onboarding2 = Image(AssetImage.onboarding2)
    static let onboarding3_1 = Image(AssetImage.onboarding3_1)
    static let onboarding3 = Image(AssetImage.onboarding3)
    
    // MARK: Notification Assets
    
    static let notificationIcon = Image(AssetImage.notificationIcon)
    
    // MARK: Login Assets
    static let notEyeIcon = Image(AssetImage.notEyeIcon)
    
    // MARK: Register
    static let CamerICon = Image(AssetImage.CamerICon)
    static let checkedIcon = Image(AssetImage.checkedIcon)
    static let unCheckedIcon = Image(AssetImage.unCheckedIcon)
    
    // MARK: SidMEnueVC
    static let profileImage = Image(AssetImage.profileImage)

    // MARK: General
    static let RightArrow = Image(AssetImage.RightArrow)
    static let TermsImage = Image("TermsImage")
    static let PolicyImage = Image("PolicyImage")
    static let CancelationImage = Image("CancelationImage")
    static let authRightArrow = Image("authRightArrow")
    static let location = Image("Location")
    static let darkLocation = Image("darkLocation")
    
    // MARK: AuctionVC
    static let FavouriteBtn = Image("FavouriteBtn")
    static let unFavouriteIcon = Image("unFavouriteIcon")
    static let carImage = Image("carImage")
    
//    MARK: TapBar
    static let vendor = Image("Vendor")
    static let order = Image("Orders")
  
}
