//
//  VendorsMenuFilterCardView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import SwiftUI

struct VendorsMenuFilterCardView: View {
    @Binding var filterObject: FilterObject
    @Binding var isVendorMenu: Bool
    @State var isNew: Bool?
    @State var isFar: Bool?
    @State var isBest: Bool?
   
    var body: some View {
                
                VStack(spacing:20){
                    Spacer()
                    Text("sort_list".localized)
                 
                    newestView
                    locationView
                    ratingView
                    buttonSection
                }
                .onAppear {
                    isNew = filterObject.isNew
                    isFar = filterObject.isFar
                    isBest = filterObject.isBest
                }
                .frame(maxHeight: .infinity)
                .background(
                    Color.backGroundColor
                )

    }
    
    private var newestView: some View {
        HStack{
            Text("oldest_to_newest".localized)
                .foregroundStyle(isNew == true ? Color.CWhite : .gray)
                .padding(5)
                .padding(.horizontal,5)
                .background(isNew == true ? Color.MainColor : .white)
                .cornerRadius(5)
                .onTapGesture {
                    isNew = true
                }
            Spacer()
            Text("newest_to_oldest".localized)
                .foregroundStyle(isNew == false ? .white : .gray)
                .padding(5)
                .padding(.horizontal,5)
                .background(isNew == false ? Color.MainColor : .white)
                .cornerRadius(5)
                .onTapGesture {
                    isNew = false
                }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var locationView: some View {
        HStack{
            Text("farthest_to_nearest".localized)
                .foregroundStyle(isFar == true ? .white : .gray)
                .padding(5)
                .padding(.horizontal,5)
                .background(isFar == true ? Color.MainColor : .white)
                .cornerRadius(5)
                .onTapGesture {
                    isFar = true
                }
            Spacer()
            Text("nearest_to_farthest".localized)
                .foregroundStyle(isFar == false ? .white : .gray)
                .padding(5)
                .padding(.horizontal,5)
                .background(isFar == false ? Color.MainColor : .white)
                .cornerRadius(5)
                .onTapGesture {
                    isFar = false
                }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var ratingView: some View {
        VStack {
            HStack{
                Text("lowest_to_highest_price".localized)
                    .foregroundStyle(isBest == true ? .white : .gray)
                    .padding(5)
                    .padding(.horizontal,5)
                    .background(isBest == true ? Color.MainColor : .white)
                    .cornerRadius(5)
                    .onTapGesture {
                        isBest = true
                    }
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack{
                Text("highest_to_lowest_price".localized)
                    .foregroundStyle(isBest == false ? .white : .gray)
                    .padding(5)
                    .padding(.horizontal,5)
                    .background(isBest == false ? Color.MainColor : .white)
                    .cornerRadius(5)
                    .onTapGesture {
                        isBest = false
                    }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    private var buttonSection: some View {
        HStack{
            SimpleSpareButton(buttonTitle: "confirm".localized, action: {
                filterObject.isNew = isNew
                filterObject.isBest = isBest
                filterObject.isFar = isFar
                isVendorMenu = false
            }, widthValue: 160, heightValue: 30)
            
            SmallButtonWithBorder(action: {
                filterObject.isNew = nil
                filterObject.isBest = nil
                filterObject.isFar = nil
                isVendorMenu = false
            }, title: "cancel".localized)
        }
        .padding(.horizontal)
        
    }
}

