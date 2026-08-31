//
//  Colors+.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 27/11/2024.
//

import Foundation
import SwiftUI
import UIKit
// Color Extension to define custom colors
extension Color {
    static let TitleColor = Color("TitleColor")
    static let CBlack = Color("CBlack") // Color from asset catalog
    static let CBlue = Color("CBlue") // Color from asset catalog
    static let MainColor = Color("MainColor") // Color from asset catalog
    static let Founts = Color("founts")
    static let SecondaryColor = Color("SecondaryColor")
    static let MainColor2 = Color("SecondaryColor") // System background color
    static let CBrown = Color("CBrown")
    static let MainColor3 = Color("MainColor3") // Color from asset catalog
    static let CGray1 = Color("CGray1") // Color from asset catalog
    static let CGray2 = Color("CGray2") // Color from asset catalog
    static let CGray3 = Color("CGray3") // System background color
    static let CWhite = Color("CWhite")
    static let CGray4 = Color("CGray4") // Color from asset catalog
    static let CGray5 = Color("CGray5") // Color from asset catalog
    static let CGreen = Color("CGreen") // Color from asset catalog
    static let CRed = Color("CRed") // System background color
    static let CSky = Color("CSky")
    
    static let DesColor = Color("DesColor")
    
    //static let calenderdeselect = Color("calenderdeselect")
    
    static let TextBorderColor = Color("TextBorderColor")
    static let TextFieldTitleColor = Color("TextFieldTitleColor")
    
    static let SidMenueTextColor = Color("SidMenueTextColor")
    static let BgView = Color("BgView")
    static let backGroundColor = Color("backGroundColor")
 
    
    // RGB color with alpha
    static func rgba(red: Double, green: Double, blue: Double, alpha: Double = 1.0) -> Color {
        return Color(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, opacity: alpha)
    }

    // Hexadecimal color (convert hex to RGB)
    static func hex(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        if hexSanitized.count == 6 {
            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            return Color(
                red: Double((rgb & 0xFF0000) >> 16) / 255.0,
                green: Double((rgb & 0x00FF00) >> 8) / 255.0,
                blue: Double(rgb & 0x0000FF) / 255.0
            )
        } else {
            return Color.black // Default to black if hex is invalid
        }
    }
}
extension UIColor {
   
    
    
    static let CBlack = UIColor(named: "CBlack")
   static let CBlue = UIColor(named: "CBlue")
    static let MainColor = UIColor(named: "MainColor")
    static let MainColor2 = UIColor(named: "MainColor2")
    static let MainColor3 = UIColor(named: "MainColor3")
    static let CGray1 = UIColor(named: "CGray1")
    static let CGray2 = UIColor(named: "CGray2")
    static let CGray3 = UIColor(named: "CGray3")
    static let CGray4 = UIColor(named: "CGray4")
    
    

    static let CGray5 = UIColor(named: "CGray5")
    static let CGreen = UIColor(named: "CGreen")
    static let CRed = UIColor(named: "CRed")
    static let TextBorderColor = UIColor(named: "TextBorderColor")
    static let TextFieldTitleColor = UIColor(named: "TextFieldTitleColor")
    
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static func hex(_ hex: String?) -> UIColor {
        var cString: String = hex?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() ?? ""
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
extension UIColor {
    
    convenience init(_ hex: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255.0, green: CGFloat((hex >> 8) & 0xFF) / 255.0, blue: CGFloat((hex) & 0xFF) / 255.0, alpha: CGFloat(255 * alpha) / 255)
    }
    
    convenience init(_ hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
            default:
                (r, g, b) = (1, 1, 0)
        }
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: (r / 255), green: (g / 255), blue: (b / 255), alpha: a)
    }
}
