//
//  OfferDetailsView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//

import SwiftUI

struct OfferDetailsView: View {

    @ObservedObject var viewModel: OfferDetailsViewModel
    
    init(viewModel: OfferDetailsViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
  
    var body: some View {
        VStack{
            AppHeaderView(Title: "Offer Details".localized) {
                viewModel.disMiss()
            }
            ShowViewState(state: viewModel.state) { Model in
                scrollView
            }
            
            Spacer()
            
        }
            
    }
    
    private var scrollView: some View {
        ScrollView{
            LazyVStack(spacing:15){
              
               
                HStack{
                    Text("Pieces List".localized)
                        .foregroundStyle(Color.MainColor)
                        .font(addFont(fontType: .Medium, size: 18))
                    Spacer()
                }.padding(.vertical,5)
                
                ForEach(viewModel.OfferModel?.items ?? [], id: \.id) { item in
                    PieceDetailsCard(offer: item)
                }
                
                if let offer = viewModel.OfferModel {
                    TotalCostCardView(Model: offer)
                }
                
                
                SimpleSpareButton(buttonTitle: "Accept Offer".localized, action: {
                    viewModel.acceptOffer(order_id: viewModel.orderId, offer_id: viewModel.offerId)
                }, widthValue: 300, heightValue: 50)
                .padding(.top)
            }
        }
        .padding(.horizontal)

    }
}


