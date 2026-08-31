//
//  MyOrdersView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 18/07/2025.
//

import SwiftUI

enum MyOrderType: String, CaseIterable {
    case new = "new"
    case onProgress = "processing"
    case running = "in_progress"
    case expired = "finished"
}

struct MyOrdersView: View {
    
    @Binding var selectedTab: Int
    @State var selectedType: MyOrderType = .new
    @ObservedObject private var viewModel: MyOrdersViewModel
    init(viewModel: MyOrdersViewModel,selectedTab: Binding<Int>) {
        _selectedTab = selectedTab
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
           
        mainContent.background(
            Color(Color.backGroundColor)
        )
    }
    
    private var mainContent: some View {
        VStack {
            AppHeaderView(Title: "My Orders".localized,hideBackButton: true) {}
            orderTypeView
            ShowViewState(state: viewModel.state) { Model in
                scrollView
            }
            Spacer()
        }
    }
    
    private var orderTypeView: some View {
        HStack(spacing:20){
            Text("New".localized)
                .underline(selectedType == .new)
                .foregroundStyle(selectedType == .new ? Color.MainColor : Color.CBlack)
                .font(.custom(AppFont.bold.rawValue, size: 16))
                .onTapGesture {
                    selectedType = .new
                    //                            viewModel.getMyOrdersData(urlEndPoint: selectedType.rawValue)
                    viewModel.changeOrderType(to: .new)
                }
            
            Text("On Progress".localized)
                .underline(selectedType == .onProgress)
                .foregroundStyle(selectedType == .onProgress ? Color.MainColor : Color.CBlack)
                .font(.custom(AppFont.bold.rawValue, size: 16))
                .onTapGesture {
                    selectedType = .onProgress
                    //                            viewModel.getMyOrdersData(urlEndPoint: selectedType.rawValue)
                    viewModel.changeOrderType(to: .onProgress)
                }
            
            Text("Running".localized)
                .underline(selectedType == .running)
                .foregroundStyle(selectedType == .running ? Color.MainColor : Color.CBlack)
                .font(.custom(AppFont.bold.rawValue, size: 16))
                .onTapGesture {
                    selectedType = .running
                    //                            viewModel.getMyOrdersData(urlEndPoint: selectedType.rawValue)
                    viewModel.changeOrderType(to: .running)
                }
            
            Text("Expired".localized)
                .underline(selectedType == .expired)
                .foregroundStyle(selectedType == .expired ? Color.MainColor : Color.CBlack)
                .font(.custom(AppFont.bold.rawValue, size: 16))
                .onTapGesture {
                    selectedType = .expired
                    //                            viewModel.getMyOrdersData(urlEndPoint: selectedType.rawValue)
                    viewModel.changeOrderType(to: .expired)
                }
            
        }
        .padding(.vertical)
    }
    
    private var scrollView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.orders.indices,id: \.self) { index in
                    let order = viewModel.orders[index]
                    MyOrdersCardView(ordersData: order, orderIndex: index + 1, selectOrder: {
                        viewModel.coordinator.showOrderDetails(orderId: "\(order.id ?? 0)")
                    })
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentOrder: order)
                        }
                }
            }
        }.scrollIndicators(.hidden) // hides the scroll indicators
        .padding(.horizontal)
        .refreshable {
            viewModel.refres()
        }
    }
}
