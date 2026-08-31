//
//  OrderPaymentSumView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 20/07/2025.
//

import SwiftUI

struct OrderPaymentSumView: View {
    
    @State var fieldText: String = ""
    @State var isTerms: Bool = false
    @State var isTermsColor: Bool = false
    @State var isVisa: Bool = true
    @State var isMasterCard: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                AppHeaderView(Title: "Order_payment_sum") {
                    
                }
                ScrollView {
                    VStack(spacing:20){
                        
                        HStack(spacing:70){
                            TitleLabel(title: "vendor_name".localized)
                            Text("some name")
                            Spacer()
                        }
                        
                        HStack(spacing:70){
                            TitleLabel(title: "country")
                            Text("some name")
                            Spacer()
                        }
                        
                        HStack(spacing:70){
                            TitleLabel(title: "city")
                            Text("some name")
                            Spacer()
                        }
                        
                        HStack(spacing:70){
                            TitleLabel(title: "address")
                            Text("some name")
                            Spacer()
                        }
                        
                        HStack(spacing:70){
                            TitleLabel(title: "delivery_type")
                            Text("some name")
                            Spacer()
                        }
                        
                        TitleLabel(title: "available_parts_menu")
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            LazyHStack(spacing: 10){
                                ForEach(0..<5){_ in
                                    AvailablePartsCard()

                                }
                            }
                        }
                        
                        TitleLabel(title: "use_wallet_balance")
                        
                        HStack{
                            Image(systemName: "wallet.pass.fill")
                                .foregroundStyle(Color.MainColor)
                                .font(.system(size: 30))
                            
                            Text("wallet_balance".localized)
                                .foregroundStyle(Color.MainColor)
                            
                                PlainUIKitTextField(
                                    text: $fieldText,
                                    placeholder: "cash".localized,
                                    keyboardType: .numberPad,
                                    isNumeric: true
                                )
                                    .frame(height: 26)
                                    .padding(13)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.CWhite)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.MainColor, lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                                    .padding(.leading, 7)
                            Spacer()
                            }
                        .padding(.trailing)
                        .padding(.trailing)
                        
                        TitleLabel(title: "enter_required_balance")
                        
                        PlainUIKitTextField(
                            text: $fieldText,
                            placeholder: "cash".localized,
                            keyboardType: .numberPad,
                            isNumeric: true
                        )
                            .frame(height: 26)
                            .padding(13)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.CWhite)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.MainColor, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                            .padding(.trailing)
                            .padding(.trailing)
                            .padding(.trailing)
                        
                        TitleLabel(title: "cost_details")
                        
                        HStack(spacing:70){
                            TitleLabel(title: "part_total_cost")
                            Text("100 rs")
                            Spacer()
                        }
                        
                        HStack(spacing:70){
                            TitleLabel(title: "charge_price")
                            Text("1000 rs")
                            Spacer()
                        }
                        
                        HStack(spacing:70){
                            TitleLabel(title: "total_cost")
                            Text("1000 rs")
                            Spacer()
                        }
                        
                        HStack(spacing:70){
                            TitleLabel(title: "wallet_balance_used")
                            Text("1000 rs")
                            Spacer()
                        }
                        
                        HStack(spacing:70){
                            TitleLabel(title: "total_payment")
                            Text("1000 rs")
                            Spacer()
                        }
                        TitleLabel(title: "choose_payment_method")
                        
                        SelectorBarWithIcon(iconName: "wallet.pass.fill", title: "visa", isSelected: $isVisa)
                            .onTapGesture {
                                isVisa = true
                                isMasterCard = false
                            }
                        
                        SelectorBarWithIcon(iconName: "wallet.pass.fill", title: "master_card", isSelected: $isMasterCard)
                            .onTapGesture {
                                isVisa = false
                                isMasterCard = true
                            }
                        
                        TermsView(isSelected: $isTerms, textColorChange: $isTermsColor)
                            .onTapGesture {
                                isTerms.toggle()
                            }
                        
                        SimpleSpareButton(buttonTitle: "confirm_payment", action: {
                            
                        }, widthValue: 320, heightValue: 50)
                        
                    }
                    .padding(.horizontal)
                    
                    
                }
            }
        }.toolbarColorScheme(.dark, for: .navigationBar) // 👈 makes status bar white
    }
}

#Preview {
    OrderPaymentSumView()
}

struct AvailablePartsCard: View {
    var body: some View {
        VStack(spacing:10){
            HStack(spacing:70){
                TitleLabel(title: "part_name")
                Text("some name")
            }
            
            HStack(spacing:70){
                TitleLabel(title: "part_number")
                Text("12")
            }
            
            HStack(spacing:70){
                TitleLabel(title: "part_type")
                Text("some name")
            }
            
            HStack(spacing:70){
                TitleLabel(title: "number")
                Text("3")
            }
            
            HStack(spacing:70){
                TitleLabel(title: "price")
                Text("100 rs")
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(style: StrokeStyle()).fill(Color.MainColor))
        .padding(1)
    }
}

struct SelectorBarWithIcon: View {
    var iconName: String
    var title: String
    @Binding var isSelected: Bool
    var body: some View {
        HStack(){
            Circle()
                .fill(isSelected ? Color.MainColor : .clear)
                .frame(width: 15,height: 15)
                .overlay {
                    ZStack{
                        Image(systemName: "checkmark")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.CWhite)
                        Circle()
                            .stroke(style: StrokeStyle())
                            .fill(isSelected ? Color.MainColor : Color.CGray1)
                        
                    }
                }
            
            Spacer()
            HStack{
                Text(title.localized)
                    .foregroundStyle(Color.MainColor)
                
                Image(systemName: iconName)
                    .foregroundStyle(Color.MainColor)
            }
        }
        .padding(10)
        .background(Color.CGray3)
        .cornerRadius(10)
    }
}
