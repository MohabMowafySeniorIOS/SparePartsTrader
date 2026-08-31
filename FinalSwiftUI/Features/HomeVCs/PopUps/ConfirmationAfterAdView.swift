//
//  ConfirmationAfterAdView.swift
//  Auctions
//
//  Created by Mohab on 12/06/2025.
//

import SwiftUI

struct ConfirmationAfterAdView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var isNavi: Bool = false
   
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack {
                    Text("choose_ad_type".localized)

                    HStack {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .onTapGesture {
                               dismiss()
                            }
                        Spacer()
                    }
                }
                .padding()
                
                Image("PolicyImage")
                
                Text("your_ad_will_be_published_soon".localized)
                Text("you_will_be_notified_soon".localized)
                Text("contact_support".localized)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .underline()
                    .onTapGesture {
                        isNavi = true
                    }
                
                HStack{
                    ContentButtonView(title: "my_ads".localized) {
                      
                    }
                    Spacer()
                    //"home"
                    //appState.restartApp();
                    CustomeButtonWithBorderColor(title: "home".localized) {
                       
                    }
                }
                .padding()

                
            }
        }
//        .ignoresSafeArea()

    }
}

#Preview {
    ConfirmationAfterAdView()
}
