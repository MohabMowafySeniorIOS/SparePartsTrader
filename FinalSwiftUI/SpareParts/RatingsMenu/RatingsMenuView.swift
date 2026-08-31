//
//  RatingsMenuView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 15/07/2025.
//

import SwiftUI

struct RatingsMenuView: View {
    @Environment(\.dismiss) var dismiss
   
    @State private var rotation: Double = 0
    @State private var isLoading = true
    
    @ObservedObject private var viewModel: VendorDetailsViewModel
    
    init(viewModel: VendorDetailsViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            mainContent
        }

    }
   
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack{
            AppHeaderView(Title: "ratings_menu") {
                dismiss()
            }
            ScrollView(showsIndicators: false){
                LazyVStack{
                    ForEach(0..<10) { item in
                        RatingsMenuCardView()
                    }
                }
            }
        }

    }
}

