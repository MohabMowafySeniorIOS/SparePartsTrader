//
//  AppHeaderView.swift
//  FinalSwiftUI
//
//  Created by Mohab on 17/05/2025.
//

import SwiftUI

struct AppHeaderView: View {
     var Title : String
    var action: () -> Void // Action closure
    var hideBackButton: Bool = false
    var body: some View {
        VStack {
            ZStack {
                Text(Title.localized).foregroundColor(Color.white)
                    .font(.custom(AppFont.bold.rawValue, size: 16))
                if !hideBackButton {
                    HStack {
                        Button(action : action) {
                            Image.RightArrow.padding().scaleEffect(x:appLanguage == "en" ? -1 : 1, y: 1)
                        }.frame(width: 32,height: 32)
                            .padding(16)
                        Spacer()
                    }
                }
                
            }
        }
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(Color.MainColor)
        .environment(\.layoutDirection,appLanguage == "en" ? .leftToRight : .rightToLeft)
        
    }
}



struct AuthHeaderView: View {
    @State var Title : String
    var action: () -> Void // Action closure
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action : action) {
                        Image.authRightArrow.padding().scaleEffect(x:appLanguage == "en" ? -1 : 1, y: 1)
                    }.frame(width: 32,height: 32)
                        .padding(16)
                    Spacer()
                }
            }
        }
        .environment(\.layoutDirection,appLanguage == "en" ? .leftToRight : .rightToLeft)
        
    }
}


