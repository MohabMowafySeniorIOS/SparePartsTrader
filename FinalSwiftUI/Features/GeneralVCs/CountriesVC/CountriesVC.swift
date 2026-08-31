//
//  CountriesVC.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 14/01/2025.
//

import SwiftUI

struct CountryListView: View {
  
    @StateObject private var viewModel = CountriesViewModel()
    @State private var isLoading = true
    @State private var rotation: Double = 0
    var body: some View {
        Group {
            if viewModel.errorMessage != nil , viewModel.errorMessage != "" {
                ToastView(message: viewModel.errorMessage ?? "", backgroundColor: .red)
                    .transition(.move(edge: .top))
                    .zIndex(1) // To make sure the toast is above other content
            }
            if viewModel.isLoading ?? false{
                LoaderView(rotation: $rotation, isLoading: $isLoading)
                    .frame(width: 100, height: 100)
            }else {
                if !(viewModel.isLoading ?? false){
                    if (viewModel.CountriesData?.count ?? 0) > 0 {
                        List(viewModel.CountriesData ?? [], id: \.id) { country in
                            Text(country.name ?? "")
                        }
                    }
                }
            }
        }.onAppear {
         //   viewModel.fetchUsers(urlEndPoint: .countries, methodType: .get)
        }
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView()
    }
}
