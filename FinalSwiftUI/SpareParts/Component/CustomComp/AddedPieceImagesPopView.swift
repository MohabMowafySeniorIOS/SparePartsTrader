//
//  AddedPieceImagesPopView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 17/07/2025.
//

import SwiftUI

struct AddedPieceImagesPopView: View {
    let onActivate: () -> Void
    let onCancel: () -> Void
    var body: some View {
        VStack{
            ZStack{
                Text("added images".localized)
                    .foregroundStyle(Color.MainColor)
                    .font(addFont(fontType: .bold, size: 18))
                HStack{
                    Button(action: onCancel) {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .foregroundColor(Color.MainColor)
                    }
                        
                    Spacer()
                }
            }
            .padding(.top,5)
            .padding(.horizontal)
            
            HStack{
                Image("carImage")
                    .frame(width: 180, height: 130)
                
                Image("carImage")
                    .frame(width: 180, height: 130)
            }
            
            HStack{
                Image("carImage")
                    .frame(width: 180, height: 130)
                
                Image("carImage")
                    .frame(width: 180, height: 130)
            }

        }
        .frame(width: 380,height: 330)
        .background(Color.CWhite)
        .cornerRadius(10)
    }
}

#Preview {
    AddedPieceImagesPopView(onActivate: {}, onCancel: {})
}
