//
//  SpareCityFilterBox.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import SwiftUI

struct SpareCityFilterBox: View {
    
    var isBoxActive: Bool
    var city: String
    
    var body: some View {
        HStack{
           Image(isBoxActive ? "check" : "uncheck").renderingMode(.template)

                Text(city)
                    .foregroundStyle(isBoxActive ? Color.CBlack : Color.CGray1)
            }
        }
    }


#Preview {
    SpareCityFilterBox(isBoxActive: false, city: "masr")
}
