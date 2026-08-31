//
//  View+.swift
//  FinalSwiftUI
//
//  Created by Mohab on 16/05/2025.
//

import SwiftUI

extension View {
    func addFont(fontType:AppFont,size:Int)->Font{
        
        return .custom(fontType.rawValue, size: CGFloat(size))
    }
}


extension View {
    func dismissKeyboardOnTap() -> some View {
        return self.onTapGesture {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first { $0.isKeyWindow }?.endEditing(true)
            }
        }
    }
}
