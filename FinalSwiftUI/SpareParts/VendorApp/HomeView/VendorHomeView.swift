//
//  VendorHomeView.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//

import Foundation
import SwiftUI

struct HomeVendor: View {
    
    @ObservedObject private var viewModel: VendorHomeViewModel
    
   
    @Binding var selectedTab: Int
    init(viewModel: VendorHomeViewModel,selectedTab: Binding<Int>) {
        _selectedTab = selectedTab
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        containView
            .background(
                Color(Color.backGroundColor)
            )
    }
    
    private var containView: some View {
        VStack {
            topParView
            ShowViewState(state: viewModel.state) { Model in
                scrollView
            }
            Spacer()
        }
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 24) {
                toggleSection
                statisticsSection
                ordersSection
                buttonSection
            }
            .padding()
        }
       
    }
    
    private var topParView: some View {
        HomeTopBar(
            userName: AuthService.userData?.full_name ?? "",
            notificationAction: {
                viewModel.coordinator.showNotification()
            }
        )
    }
    
    // MARK: Toggle Section
    private var toggleSection: some View {
        HStack {
           
            Text("home.receive_orders".localized)
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            
            Toggle("", isOn: $viewModel.isRecivingOrder)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.SecondaryColor))
                .onChange(of: viewModel.isRecivingOrder) { newValue in
                       viewModel.toggleRecievingOrder(status: newValue)
                   }
        }
    }
    
    // MARK: Statistics
    @ViewBuilder
    private var statisticsSection: some View {
        HStack {
            Text("home.statistics")
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
        }
       
       
        VStack(spacing: 14) {
            StatRow(title: "home.sent_offers_count".localized, value: "\(viewModel.state.data??.offers?.total ?? 0) " + "Offer".localized)
            StatRow(title: "home.sent_offers_total".localized, value: "\(viewModel.state.data??.offers?.total_value ?? 0) " + "R.S".localized)
            StatRow(title: "home.orders_count".localized, value: "\(Int(viewModel.state.data??.orders?.total ?? 0)) " + "Order".localized)
            StatRow(title: "home.orders_total".localized, value: "\(viewModel.state.data??.orders?.total_value ?? 0) " + "R.S".localized)
            StatRow(title: "home.completed_orders".localized, value: "\(Int(viewModel.state.data??.orders?.completed ?? 0)) " + "Order".localized)
            StatRow(title: "home.cancelled_orders".localized, value: "\(Int(viewModel.state.data??.orders?.cancelled ?? 0)) " + "Order".localized)
        }
    }
    
    // MARK: Orders
    @ViewBuilder
    private var ordersSection: some View {
        if (viewModel.state.data??.latest_orders?.count ?? 0) > 0 {
            HStack {
                Text("home.last_orders".localized)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
        }
      
        
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                
                ForEach(viewModel.state.data??.latest_orders ?? [],id: \.id) { order in
                    OrderCard(Model: order)
                        .onTapGesture {
                        viewModel.coordinator.showOrderDetails(orderId: "\(order.id ?? 0)")
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }
    
    // MARK: Button
    private var buttonSection: some View {
        Button {
            selectedTab = 1
        } label: {
            Text("home.show_all".localized)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.MainColor)
                .cornerRadius(30)
        }
        .padding(.top, 10)
    }
}


// MARK: Stat Row
struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
           
            Text(LocalizedStringKey(title))
                .foregroundColor(.SecondaryColor)
            Spacer()
            Text(value)
                .font(.body)
            
        }
    }
}


// MARK: Order Card
struct OrderCard: View {
    var Model: Order
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            
            CardRow(title: "order.id".localized, value: Model.orderNumber ?? "")
            CardRow(title: "order.type".localized, value: Model.orderType?.label ?? "")
            CardRow(title: "order.pieces".localized, value: "\(Model.itemsCount ?? 0)")
          //  CardRow(title: "order.city".localized, value: Model.)
            CardRow(title: "order.date".localized, value: (Model.createdAt ?? "").splitDate()?.date ?? "")
            CardRow(title: "order.time".localized, value: (Model.createdAt ?? "").splitDate()?.time ?? "")
        }
        .padding()
        .frame(width: 240)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.SecondaryColor.opacity(0.7), lineWidth: 1.5)
        )
        .cornerRadius(18)
    }
    

}
extension String {
    func splitDate() -> (date: String, time: String)? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, yyyy h:mm a"
        
        var usedLocale: Locale?
        var parsedDate: Date?
        
        // try Arabic
        formatter.locale = Locale(identifier: "ar")
        parsedDate = formatter.date(from: self)
        if parsedDate != nil {
            usedLocale = formatter.locale
        }
        
        // try English if Arabic failed
        if parsedDate == nil {
            formatter.locale = Locale(identifier: "en")
            parsedDate = formatter.date(from: self)
            if parsedDate != nil {
                usedLocale = formatter.locale
            }
        }
        
        guard let date = parsedDate, let locale = usedLocale else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "d MMMM, yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = locale
        timeFormatter.dateFormat = "h:mm a"
        
        return (
            dateFormatter.string(from: date),
            timeFormatter.string(from: date)
        )
    }
}

// MARK: Card Row
struct CardRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .foregroundColor(.SecondaryColor)
            
            Spacer()
            Text(value)
        }
    }
}
