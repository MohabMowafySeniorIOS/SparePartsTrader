//
//  SelectView.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 27/11/2024.
//

import Foundation
import SwiftUI
struct SelectedCustomView: View {
    @Binding var isSelected :Bool
    @State var title :String
    
    var action: () -> Void // Action closure
    var body: some View {
      

                Button(action:action) {
                    HStack {
                        ZStack {
                            HStack {
                                
                                Image(isSelected ? "check" : "uncheck").renderingMode(.template).tint(isSelected ? Color.MainColor : Color.CGray1)
                                    .padding(14)
                                Spacer()
                            }
                          
                            
                            HStack {
                                Spacer()
                                    Text(title)
                                    .foregroundColor(isSelected ? Color.MainColor : Color.CGray1)
                                    .font(.custom(AppFont.Regular.rawValue, size: 16))
                                
                                Spacer()
                            }
                        }
                      
                       
                     
                       
                        
                                
                    }
                }.frame(width: .infinity,height: 48)
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke((isSelected) ? Color.MainColor : Color.gray.opacity(0.1), lineWidth: 1))
            .background(isSelected ?  Color.MainColor.opacity(0.1) : Color.clear)
            
    }
}
#Preview {
    SelectedCustomView(isSelected: .constant(true), title:"Opened") {
        
    }
    
}
