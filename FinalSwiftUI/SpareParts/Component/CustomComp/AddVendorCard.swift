//
//  AddCityCard 2.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 16/07/2025.
//

import SwiftUI

struct AddVendorCard: View {
    let Model: Trader
    var deleteAction:()->Void
    var body: some View {
        VStack(spacing:10){
            VStack(alignment:.leading){
                HStack(spacing:50){
                    VStack(alignment:.leading,spacing:10){
                        Image(systemName: "person")
                            .foregroundStyle(Color.MainColor)
                        
                        Image(systemName: "house")
                            .foregroundStyle(Color.MainColor)
                        
                        
                        Image(systemName: "house")
                            .foregroundStyle(Color.MainColor)
                    }
                    VStack(alignment:.leading,spacing:10){
                        Text(Model.tradeName ?? "")
                            .foregroundStyle(Color.MainColor)
                        
                        Text(Model.country?.name ?? "")
                            .foregroundStyle(Color.MainColor)
                        
                        Text(Model.city?.name ?? "")
                            .foregroundStyle(Color.MainColor)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            
            SimpleSpareButton(buttonTitle: "Delete".localized, action: {
                deleteAction()
            }, widthValue: 150, heightValue: 30)
            
        }
        .padding(10)
        .frame(width: 250)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle())
                .fill(Color.MainColor)
        }
        .padding(1)
    }
    
   
}
