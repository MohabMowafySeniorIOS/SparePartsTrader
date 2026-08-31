//
//  FAQVC.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 19/12/2024.
//


import SwiftUI


struct FAQScreen: View {
    
    
    @ObservedObject private var viewModel: FAQViewModel
    
    init(viewModel: FAQViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
  
    @State private var rotation: Double = 0
    @State private var isLoading = true
    var body: some View {
        VStack {
            AppHeaderView(Title: "menu_faq".localized) {
                viewModel.disMiss()
            }
            
            ShowViewState(state: viewModel.state) { Model in
                mainContent
            }
            
           
            Spacer()
        }.background(
            Color(Color.backGroundColor)
        )
       
        
    }
    
   
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.ModelFAQ,id: \.id) { item in
                    FAQRow(
                        item: item
                        
                    )
                    
                }
            }
            .padding([.top],16)
        }
        
    }
}

struct FAQRow: View {
    @State var item: FAQ
    
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 6) {
            HStack {
                Text(item.question ?? "")
                    .font(.body)
                    .foregroundColor(.SecondaryColor)
                Spacer()
                Image(systemName: item.isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.SecondaryColor)
            }
            .padding()
            .background(Color.SecondaryColor.opacity(0.08))
            .cornerRadius(16)
            .onTapGesture {
                item.togle()
            }

            if item.isExpanded {
                HStack {
                    Text(item.answer ?? "")
                        .font(.subheadline)
                        .foregroundColor(.SecondaryColor)
                        .padding(16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    Spacer()
                }

            }
        }.background(Color.CWhite)
            .animation(.easeInOut(duration: 0.3), value: item.isExpanded)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
            .padding(.horizontal)
        
    }
}

