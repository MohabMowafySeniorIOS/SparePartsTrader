//
//  LanguageVC.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 27/12/2024.
//

import SwiftUI


import SwiftUI

class LanguageManager: ObservableObject {
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
            UserDefaults.standard.synchronize()
            Bundle.setLanguage(currentLanguage)
        }
    }
    
    init() {
        currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        UserDefaults.standard.synchronize()
        Bundle.setLanguage(currentLanguage)
    }
    
    var layoutDirection: LayoutDirection {
        currentLanguage == "ar" ? .rightToLeft : .leftToRight
    }
}
extension Bundle {
    private static var didSwizzle = false

    static func setLanguage(_ language: String) {
        if !didSwizzle {
            object_setClass(Bundle.main, LanguageBundle.self)
            didSwizzle = true
        }
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.set(language, forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
    }
}

private class LanguageBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = Bundle.main.path(forResource: UserDefaults.standard.string(forKey: "selectedLanguage"), ofType: "lproj"),
              let bundle = Bundle(path: path)
        else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
