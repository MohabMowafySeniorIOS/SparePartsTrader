//
//  HomeSearchBar.swift
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//
import SwiftUI
var searchText = ""
struct HomeSearchBar: View {
    
    @Binding var searchFieldText: String
    var searchAction: ()->Void
    var body: some View {
        HStack{
            Button {
                searchAction()
            } label: {
                Text("search".localized)
                    .font(.custom(AppFont.bold.rawValue, size: 16))
                    .padding()
                    .padding(.horizontal)
                    .foregroundStyle(Color.CWhite)
                    .background(Color.MainColor)
            }
            HStack{
                PlainUIKitTextField(
                    text: $searchFieldText,
                    placeholder: "vendor_name".localized,
                    font: UIFont(name: AppFont.bold.rawValue, size: 16) ?? .boldSystemFont(ofSize: 16),
                    textColor: UIColor(Color.MainColor)
                )
                .frame(height: 34)
                .onChange(of: searchFieldText) { newValue in
                    searchText = newValue
                }
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.MainColor)
            }
            .padding(.horizontal)
            
        }
        .onAppear {
            searchFieldText = searchText
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle())
                .fill(Color.MainColor)
                .padding(1)
        )
        .cornerRadius(10)
        .padding(.vertical)
    }
}
