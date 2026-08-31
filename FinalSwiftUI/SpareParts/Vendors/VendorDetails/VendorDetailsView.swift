//
//  VendorDetailsView.swift
//  MyAuctions
//
//  Created by Mohab on 14/07/2025.
//

import SwiftUI

struct VendorDetailsView: View {
    
    var rating: Double
    @State var starSize: CGFloat = 20
    @State var starPadding: CGFloat = 3
    @State var tabSelection: Int = 0
    
    @State var currentImage: String?
    
    
    @State var isFavourit: Bool = false
    @State private var goRating = false
    
    @ObservedObject private var viewModel: VendorDetailsViewModel
    init(viewModel: VendorDetailsViewModel, rating: Double ) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.rating = rating
    }
    
    var body: some View {
        mainContent
            .background(
                Color(Color.backGroundColor)
            )
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack{
            AppHeaderView(Title: "Vendor Details".localized) {
                viewModel.coordinator.disMiss()
            }
            
            ShowViewState(state: viewModel.state) { Model in
                scrollView
            }
            Spacer()
            handleNavigation
        }
        
    }
    
    private var scrollView: some View {
        
        VStack(spacing:0){
            ScrollView{
                vendorInfoView
                imagesView
                vendorDetailsView
                countryAndCityView
            }
            buttonsView
        }
    }
    
    private var vendorInfoView: some View {
        HStack(alignment: .top){
            vendorData
            Spacer()
            favouriteButton
        }
        .padding()
        
    }
    
    private var vendorData: some View {
        HStack(alignment:.top){
            RemoteImageView(imageUrl: viewModel.vendorModel?.logo?.path ?? "")
                .frame(width: 70, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.SecondaryColor, lineWidth: 2)
                )
                .padding(.trailing)
            VStack(alignment: .leading, spacing:15){
                Text(viewModel.vendorModel?.tradeName ?? "")
                    .font(.custom(AppFont.bold.rawValue, size: 16))
                    .foregroundStyle(Color.SecondaryColor)
                
                HStack{
                    Text(String(rating))
                        .font(.custom(AppFont.bold.rawValue, size: 16))
                        .foregroundStyle(.gray)
                        .padding(.trailing,10)
                    
                    CustomStarRatingView(rating: rating, startSize: $starSize, paddingValue: $starPadding)
                }
                ratingButton
            }
            Spacer()
        }
    }
    
    private var ratingButton: some View {
        SmallButtonComponent(action: {
            goRating = true
        }, title: "Show Ratings List".localized)
    }
    
    private var favouriteButton: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 30))
            .foregroundStyle( viewModel.vendorModel?.isFavorite ?? false ? Color.CRed : Color.CGray2)
            .onTapGesture {
                viewModel.handleFavourite(vendorId: viewModel.vendorId)
            }
        //                                .onChange(of: //favouritViewModel.isFavourit ?? false) { oldValue, newValue in
        //                                    isFavourit = newValue
        //                                }
        
    }
    
    @ViewBuilder
    private var imagesView: some View {
        if let image = currentImage {
            RemoteImageView(imageUrl: image)
                .frame(width: 200, height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.SecondaryColor, lineWidth: 2)
                )
                .clipped()
                .cornerRadius(8)
                .padding(.bottom,10)
        }
        HorizontalImageScroller(images: viewModel.vendorModel?.images ?? [], currentImage: $currentImage)
    }
    
    @ViewBuilder
    private var vendorDetailsView: some View {
        VStack(spacing: 12) {
            TitleLabel(title: "About Vendor".localized)
            
            Text(viewModel.vendorModel?.description ?? "")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(style: StrokeStyle())
                        .fill(Color.CGray1)
                )
            
        }.padding()
        
    }
    
  
    private var countryAndCityView: some View {
        VStack(spacing: 10) {
            DoubleHTitleLabel(head: "country".localized, tail: viewModel.vendorModel?.country?.name ?? "")
                .padding(.horizontal)
            DoubleHTitleLabel(head: "city".localized, tail: viewModel.vendorModel?.city?.name ?? "")
                .padding(.horizontal)
            distanceView
        }
       
    }
    
    @ViewBuilder
    private var distanceView: some View {
        HStack{
            Text("distance_between_vendor_customer".localized)
            Image.darkLocation
            Spacer()
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var buttonsView: some View {
        VStack(spacing: 16) {
            
            CustomButtonWithIcon(action: {
                viewModel.openGoogleMaps(lat: viewModel.vendorModel?.latitude ?? 0.0, lng: viewModel.vendorModel?.longitude ?? 0.0)
            }, title: "Show Location".localized)
            
            
            
            CustomeButtonWithBorderColor(title: "create_order".localized) {
             viewModel.coordinator.createOrder(mainOrderType: .custom, specificVendor: viewModel.vendorModel)
            }
        }.padding(.horizontal,40)
            
        
        
    }
    
    @ViewBuilder
    private var handleNavigation: some View {
        NavigationLink("",
                       destination:  RatingsView(viewModel: RatingViewModel(traderId: "\(viewModel.vendorModel?.id ?? 0)")), isActive: $goRating)
        .navigationBarHidden(true)
        .hidden()
        
    }
}





struct CustomButtonWithIcon: View {
    var action: () -> Void
    var title: String
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 16){
                Spacer()
                Text(title.localized)
                    .foregroundStyle(.white)
                    .font(.custom(AppFont.bold.rawValue, size: 16))
                
                Image.location
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 35)
                    .font(.custom(AppFont.bold.rawValue, size: 16))
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.MainColor)
            )
            
        }
    }
}
