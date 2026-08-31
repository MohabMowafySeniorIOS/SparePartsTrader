//
//  AdditionalAddressDescribtionView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//

import SwiftUI

struct xxxx: View {
    
    @ObservedObject var viewModel: AdditionalAddressDescribtionViewModel
    init(viewModel: AdditionalAddressDescribtionViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack{
            VStack(spacing:20){
                HStack{
                    TitleLabel(title: "address_describtion")
                    Spacer()
                }
                
                Text("address_describtion_textoquwehfqbwuhecbiuhewbictuhwebirtcuhweirutbciewurthbciuewbrt")
                    .foregroundStyle(Color.CBlack)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(Color.CWhite)
                    .cornerRadius(10)
                
                HStack{
                    SimpleSpareButton(buttonTitle: "automatic_gps", action: {
                        viewModel.disMiss()
                    }, widthValue: 150, heightValue: 35)
                    Spacer()
                    SmallButtonWithBorder(action: {
                        viewModel.AddAddressData(paramter: .init(is_default: "1", title:"dasdas",latitude: "30.21332",longitude: "30.21332",address_text: "dasdasdas",description: "dasd"))
                    }, title: "add")
                }
                .padding(.horizontal)
                
            }.padding()
        }
        .background(Color.CGray3)
    }
}

