//
//  SplashVC.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//

import SwiftUI


struct SplashScreenView: View {

    var body: some View {
            ZStack {
                VStack(spacing: 16) {
                    Image.Splashlogo
                        .resizable()
                        .logoSize()
                }
            }
            
    }
}


#Preview {
    SplashScreenView()
}
