//
//  CstomLabel.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 27/11/2024.
//

import Foundation
import SwiftUI
// Custom Label with Image Component

struct HeaderTitleLabe: View {
   
    var labelText: String
    var is_required: Bool
    var imageSize: CGFloat = 24 // Default size for the image
    @State private var isEditing = false
    var body: some View {
        HStack() {
            Text(labelText)
                .font(addFont(fontType: .bold, size: 12))
                .foregroundColor(Color.TextFieldTitleColor)
                .frame(maxWidth: .infinity, alignment: .leading)
             Spacer()
        }
       
    }
}




struct CustomLabel_text: View {
    var imageName: String
    var labelText: String
  
    var imageSize: CGFloat = 24 // Default size for the image
    @State private var isEditing = false
    var body: some View {
        HStack() {
            Text(labelText)
                .font(.custom(AppFont.Medium.rawValue, size: 16))
                .foregroundColor(Color.TextFieldTitleColor)
               
        }
       
    }
}


struct CustomValidationLabel: View {
    var imageName: String
    var labelText: String
    var imageSize: CGFloat = 24 // Default size for the image
    @State private var isEditing = false
    var body: some View {
        HStack() {
            Text(labelText)
                
                .foregroundColor(Color.CRed)
                .font(.custom(AppFont.Medium.rawValue, size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
       
    }
}
#Preview {
    HeaderTitleLabe(labelText: "dasdasdasd", is_required: false)
    
}
