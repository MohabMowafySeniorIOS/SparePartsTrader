//
//  CreateOrderComponents.swift
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//

import Foundation
import SwiftUI

struct NormalAppBar: View {
    var title: String
    @State var action: () -> Void
    var body: some View {
        ZStack{
            Text(title.localized)
                .foregroundStyle(Color.CWhite)
                .font(addFont(fontType: .bold, size: 18))
            HStack{
                Image.RightArrow
                    .resizable()
                    .frame(width: 26, height: 12)
                    .padding(.leading, 12)
                    .scaleEffect(x:appLanguage == "ar" ? -1 : 1, y: 1)
                
                //                    .font(.title)
                //                    .foregroundColor(Color.white)
                Spacer()
            }
            .onTapGesture {
                action()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.MainColor)
    }
}

struct DoubleHTitleLabel: View {
    
    var head: String
    var tail: String
    
    var body: some View {
        HStack(spacing: 16){
            Text(head.localized)
                .foregroundStyle(Color.Founts)
                .font(addFont(fontType: .bold, size: 16))
            Text(tail.localized)
                .foregroundStyle(Color.Founts)
                .font(addFont(fontType: .Regular, size: 16))
            Spacer()
        }
        
    }
}

struct AddedCarSelectionBar: View {
    var title: String
    @Binding var isClicked: Bool
    var addCar: (()-> Void)?
    var body: some View {
        HStack{
            HStack{
                Text(title.localized)
                    .foregroundStyle(Color.MainColor)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 20))
                    .rotationEffect(Angle(degrees: isClicked ? 180 : 0))
                    .onTapGesture {
                        isClicked.toggle()
                    }
            }
            .padding(.horizontal)
            .frame(width: 300,height: 40)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle())
                    .fill(Color.MainColor)
            )
            .padding(.trailing)
            Spacer()
            
            Image(systemName: "plus")
                .foregroundStyle(Color.MainColor)
                .font(.system(size: 30))
                .onTapGesture {
                    addCar?()
                }
            
        }
    }
}

struct PartCard: View {
    let part: PartModel
    let id: Int
    var showPictureAction: (()->Void)
    var deletePiece: (()->Void)
    var body: some View {
        VStack{
            Text("\(id)")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
                .frame(width: 25,height: 25)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(style: StrokeStyle())
                        .fill(Color.MainColor)
                        .padding(1)
                )
            VStack (spacing: 10){
                // ID at the top center
                
                HStack {
                    Text("Piece Name".localized)
                        .foregroundStyle(Color.MainColor)
                    Spacer()
                    Text(part.name)
                    Spacer()
                }
                HStack {
                    Text("Piece Number".localized)
                        .foregroundStyle(Color.MainColor)
                    Spacer()
                    Text(part.number)
                    Spacer()
                }
                HStack {
                    Text("order.pieces".localized)
                        .foregroundStyle(Color.MainColor)
                    Spacer()
                    Text("\(part.quantity)")
                    Spacer()
                }
                HStack {
                    Text("Piece Type".localized)
                        .foregroundStyle(Color.MainColor)
                    Spacer()
                    Text(part.type.localized)
                    Spacer()
                }
                HStack{
                    Spacer()
                    VStack (spacing: 10){
                        Button {
                            showPictureAction()
                        } label: {
                            Text("show_pictures".localized)
                                .foregroundStyle(Color.CWhite)
                                .frame(width: 150, height: 30)
                                .background(
                                    Color.MainColor
                                        .cornerRadius(20)
                                )
                        }
                        
                        Button {
                            deletePiece()
                        } label: {
                            Text("delete_piece".localized)
                                .foregroundStyle(Color.MainColor)
                                .frame(width: 150, height: 30)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(style: StrokeStyle())
                                        .fill(Color.MainColor)
                                )
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(width: 200,height: 220)
        .padding(10)
        .padding(.vertical,5)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(style: StrokeStyle())
                .fill(Color.MainColor)
            
        ).padding(1)
        
    }
}

struct PartsList: View {
    @Binding var parts: [PartModel]
    var addPartAction: (()-> Void)
    var showImages: (()-> Void)
    var body: some View {
        VStack(alignment: .trailing) {
            HStack{
                Text("added_parts_menu".localized)
                Spacer()
                Image(systemName: "plus")
                    .foregroundStyle(Color.MainColor)
                    .font(.system(size: 30))
                    .onTapGesture {
                        addPartAction()
                    }
            }
            .padding(.trailing)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(parts.indices, id: \.self) { idx in
                        PartCard(part: parts[idx], id: idx + 1) {
                            showImages()
                        } deletePiece: {
                            parts.remove(at: idx)
                        }
                        
                    }
                }
            }
        }
    }
}

struct DeliveryTypeSelector: View {
    @Binding var selectedType: DeliveryTypeEnum
    var fieldType: DeliveryTypeEnum
    var title: String
    
    var body: some View {
        HStack() {
            Circle()
                .fill(selectedType == fieldType ? Color.MainColor : .clear)
                .frame(width: 15,height: 15)
                .overlay {
                    ZStack{
                        Image(systemName: "checkmark")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.CWhite)
                        Circle()
                            .stroke(style: StrokeStyle())
                            .fill(selectedType == fieldType ? Color.MainColor : Color.CGray1)
                        
                    }
                }
            
            Text(title.localized)
            Spacer()
        }
    }
}
struct CreateOrderSelectionBar: View {
    
    var isChecked: Bool
    var title: String
    var imageName: String
    var body: some View {
        HStack {
            if !isChecked {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(style: StrokeStyle())
                    .fill(Color.CGray1)
                    .frame(width: 20, height: 20)
                    .padding(.trailing)
            } else {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.MainColor)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.CWhite)
                    }
                    .padding(.trailing)
            }
            
            Text(title.localized)
                .foregroundStyle(isChecked ? Color.MainColor : Color.CGray1)
                .padding(.trailing)
            
            Image(systemName: imageName)
                .font(.system(size: 20))
            
            Spacer()
        }
        
    }
}
