//
//  NoNetView.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 16/01/2025.
//

import SwiftUI

struct NoNetView: View {
    var title: String
    var image : String
    var Btn_Title : String
    var body: some View {
        VStack(spacing: 32) {
            Image(image)
                       .resizable() // Makes the image resizable
                       // .scaledToFit() // Scales the image to fit within its parentsdohgfoisdjhoifjiosdjoi
                       .frame(width: 245, height: 236) // Set the frame size
                       // .background(.clear)
            VStack(spacing: 75) {
                Text(title)
                    .font(.custom(AppFont.bold.rawValue, size: 20))
                
                ContentButtonView(title: Btn_Title) {
                    print("Back To Home Press")
                    
                }
                  
            }
        }.padding(16)
        
      
    }
}

#Preview {
    NoNetView(title: "Something went wrong! 🔧".localized, image: "Clip path group", Btn_Title: "Back To Home".localized)
}
