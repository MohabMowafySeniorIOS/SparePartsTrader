//
//  RatingsView.swift
//  MyAuctions
//
//  Created by Mohab on 07/07/2025.
//

import SwiftUI


struct RatingsView: View {
    @Environment(\.dismiss) var dismiss
   
    @ObservedObject private var viewModel: RatingViewModel
    init(viewModel: RatingViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        mainContent
            .navigationBarHidden(true)
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
           headerView
            ShowViewState(state: viewModel.state) { Model in
                ratingView
            }
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
    
    private var headerView: some View {
        AppHeaderView(Title: "ratings_menu") {
          dismiss()
        }
    }
    
    private var ratingView: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(viewModel.ratings ?? [], id: \.id) { item in
                    RatingSingleCardView(card: item)
                }
            }
           
        }
    }
}



