//
//  AddAddressView.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//

import Foundation
import SwiftUI
//import GoogleMaps

struct GoogleMapView : UIViewRepresentable {
    
    @Binding var camera: GMSCameraPosition
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.animate(to: camera)
    }
}
import SwiftUI
import GoogleMaps

struct AdditionalAddressDescribtionView: View {
    
    @State private var camera = GMSCameraPosition(
        latitude: 24.7136,
        longitude: 46.6753,
        zoom: 16
    )
//    
    @State private var address = ""
    @State private var details = ""
    
    @ObservedObject var viewModel: AdditionalAddressDescribtionViewModel
    init(viewModel: AdditionalAddressDescribtionViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        
    }
    
    var body: some View {
        ZStack {
            
            // MARK: Google Map
            GoogleMapView(camera: $camera)
                .ignoresSafeArea()
            
            // MARK: Center Pin
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 44))
                .foregroundColor(Color.MainColor)
                .background(
                    Circle()
                        .fill(Color.MainColor.opacity(0.2))
                        .frame(width: 90, height: 90)
                )
            
            VStack {
                headerView
                searchBar
                    .padding(.horizontal)
                    .padding(.top, 6)
                
                Spacer()
                
                bottomSheet
            }
        }
    }
    
    private var headerView: some View {
          AppHeaderView(Title: "Messages".localized) {
              viewModel.disMiss()
          }
      }
}
extension AdditionalAddressDescribtionView {
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("ابحث عن العنوان", text: $address)
                .multilineTextAlignment(.trailing)
            
            Image(systemName: "location.fill")
                .foregroundColor(Color.MainColor)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.15), radius: 6)
    }
}
extension AdditionalAddressDescribtionView {
    
    
    var bottomSheet: some View {
        VStack(alignment: .trailing, spacing: 16) {
            
            Text("وصف إضافي للعنوان")
                .foregroundColor(Color.MainColor)
                .font(.headline)
            
            TextEditor(text: $details)
                .frame(height: 120)
                .padding(8)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)

            HStack{
                SimpleSpareButton(buttonTitle: "automatic_gps".localized, action: {
                    viewModel.disMiss()
                }, widthValue: 150, heightValue: 35)
                Spacer()
                SmallButtonWithBorder(action: {
                    viewModel.AddAddressData(paramter: .init(is_default: "1", title:"dasdas",latitude: "30.21332",longitude: "30.21332",address_text: "dasdasdas",description: "dasd"))
                }, title: "add".localized)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemGray6))
        //.cornerRadius(30, corners: [.topLeft, .topRight])
    }
}
