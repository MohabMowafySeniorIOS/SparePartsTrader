//
//  ImageViewModifier.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import Foundation
import SwiftUI
struct ImageModifier: ViewModifier {
   let width: CGFloat
    let height: CGFloat
    func body(content: Content) -> some View {
        content
           
            
            .frame(width: width, height: height)
            .scaledToFill()
            
            .clipped()
            .cornerRadius(8)
            .padding(.trailing,10)
        
    }
}
extension View {
    func mainImageFormation(width: CGFloat, height: CGFloat)-> some View{
        modifier(ImageModifier(width: width, height: height))
         
        
    }
}
