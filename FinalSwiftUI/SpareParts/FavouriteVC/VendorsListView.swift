//
//  VendorsListView.swift
//  SpareParts
//
//  Created by Mohab on 07/02/2026.
//

import Foundation
import SwiftUI

struct VendorsListView: View {
     var vendors: [Trader]
    var orderNow: (Trader)->()
    var favouriteAction: (Trader)->()
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(vendors, id: \.id) { vendor in
                    VendorGridCard(orderNow: {
                        orderNow(vendor)
                    }, vendorsModel: vendor, favouriteAction: {
                        favouriteAction(vendor)
                    })
//                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
    }
}

