//
//  SkipButton.swift
//  FinalSwiftUI
//
//  Created by Mohab on 16/05/2025.
//

import SwiftUI


import SwiftUI
struct SkipButton: View {
    var title: String
    var action: () -> Void // Action closure
   
    var body: some View {
       VStack(spacing: 20) {
           Button(action : action) {
               
               Text(title.localized)
                    .font(.custom(AppFont.bold.rawValue, size: 16))
                    .foregroundColor(Color.MainColor)
                    //.frame(width:.infinity,height: 48)
              
                   
                    
                
                   
        }
              
               .foregroundColor(Color.MainColor)
             
      
            }
           
    }
}

