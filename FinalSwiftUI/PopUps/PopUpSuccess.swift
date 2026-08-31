//
//  PopUpSuccess.swift
//  SpareParts
//
//  Created by Mohab on 05/03/2026.
//

import Foundation
import SwiftUI
struct SuccessPopupView: View {
    
    var message: String
    var onClose: () -> Void
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.green)
            
            Text(message)
                .font(.title3)
                .fontWeight(.semibold)
            
            Button("Done".localized) {
                onClose()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(Color.MainColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(40)
        .background(.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
