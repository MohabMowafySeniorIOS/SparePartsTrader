//
//  CustomButton.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 27/11/2024.
//

import Foundation
import SwiftUI
struct ContentButtonView: View {
    var title: String
    var action: () -> Void // Action closure
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action : action) {
                Spacer()
                Text(title.localized)
                    .font(addFont(fontType: .bold, size: 17))
                    .foregroundColor(.white)
                Spacer()
            }.mainButtunFormating()
        }
    }
}


struct SelectedContentButtonView: View {
    var title: String
    var action: () -> Void // Action closure
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action : action) {
                Spacer()
                Text("")
                    .font(addFont(fontType: .Regular, size: 14))
                    .foregroundColor(.clear)
                //.frame(width:.infinity,height: 48)
                Spacer()
                
                
                
                
            }.frame(width:.infinity,height: 48)
                .background(Color.clear)
                .cornerRadius(10)
                .padding(0)
            
        }
        
    }
}
#Preview {
    ContentButtonView(title: "Test Button"){
        
    }
    
}















