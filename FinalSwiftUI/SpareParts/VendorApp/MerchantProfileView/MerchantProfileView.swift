//
//  MerchantProfileView.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//

import Foundation
import SwiftUI

struct MerchantProfileView: View {
    @ObservedObject private var viewModel: MerchantProfileViewModel
    
    init(viewModel: MerchantProfileViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            AppHeaderView(Title: "merchant.profile_title".localized) {
                viewModel.coordinator.disMiss()
            }
            ShowViewState(state: viewModel.state) { Model in
                scrollView
            }
            
            Spacer()
            updateButton
        }.background(
            Color(Color.backGroundColor)
        )
        .onAppear {
            viewModel.getProfileData()
        }
        
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 16) {

                basicInfoSection

                imagesSection

                descriptionSection

                addressSection

                commercialSection

                bankSection

                Spacer(minLength: 30)
            }
            .padding()
        }

    }
    
    private var updateButton: some View {
        ContentButtonView(title: "Update".localized) {
            viewModel.showUpdateFileBusniss(userModel: viewModel.userModel)
        }.padding()
    }
}

#Preview {
    MerchantProfileView(viewModel: MerchantProfileViewModel(coordinator: MainCoordinator(appCoordinator: AppCoordinator())))
}


// MARK: Bank Section
extension MerchantProfileView {

    var bankSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            TitleLabel(title: "merchant.bank_info".localized)

            InfoRowTrader(title: "merchant.bank_name".localized, value: viewModel.userModel?.trader?.bank_name ?? "")
            InfoRowTrader(title: "merchant.beneficiary_name".localized, value: viewModel.userModel?.trader?.bank_account_name ?? "")
            InfoRowTrader(title: "merchant.account_number".localized, value: viewModel.userModel?.trader?.bank_account_number ?? "")
            InfoRowTrader(title: "merchant.iban".localized, value: viewModel.userModel?.trader?.bank_iban ?? "")
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}




// MARK: Basic Info
extension MerchantProfileView {

    var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            TitleLabel(title: "merchant.basic_info".localized)

            InfoRowTrader(title: "merchant.name_ar".localized, value: viewModel.userModel?.trader?.trade_name ?? "")
            InfoRowTrader(title: "merchant.name_en".localized, value: viewModel.userModel?.trader?.full_name_en ?? "")

            HStack {
                Text("merchant.logo".localized)
                    .foregroundColor(Color.SecondaryColor)
                Spacer()
                RemoteImageView(imageUrl: viewModel.userModel?.trader?.logo?.path ?? "")
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)

            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}


// MARK: Images
extension MerchantProfileView {

    var imagesSection: some View {
        VStack(alignment: .trailing, spacing: 14) {

            TitleLabel(title: "merchant.images_docs".localized)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.userModel?.trader?.images ?? [], id: \.id) { image in
                        RemoteImageView(imageUrl: image.path ?? "")
                            .scaledToFill()
                            .frame(width: 110, height: 90)
                            .clipped()
                            .cornerRadius(12)
                    }
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}


// MARK: Description
extension MerchantProfileView {

    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            TitleLabel(title: "merchant.desc_ar".localized)

            Text(viewModel.userModel?.trader?.description_ar ?? "")
                    .font(.footnote)
                    .foregroundColor(.secondary)

            TitleLabel(title: "merchant.desc_en".localized)

            Text(viewModel.userModel?.trader?.description_en ?? "")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}


// MARK: Address
extension MerchantProfileView {

    var addressSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            TitleLabel(title: "merchant.address_details".localized)

            InfoRowTrader(title: "merchant.country".localized, value: viewModel.userModel?.trader?.country?.name ?? "")
            //InfoRowTrader(title: "merchant.region".localized, value: viewModel.userModel?.trader?.city?.name ?? "")
            InfoRowTrader(title: "merchant.city".localized, value: viewModel.userModel?.trader?.city?.name ?? "")

            Button {

            } label: {
                Text("merchant.show_map".localized)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.MainColor)
                    .cornerRadius(25)
                    .onTapGesture {
                        viewModel.openGoogleMaps(lat: viewModel.userModel?.trader?.latitude ?? 0.0, lng: viewModel.userModel?.trader?.longitude ?? 0.0)
                    }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}


// MARK: Commercial Register
extension MerchantProfileView {

    var commercialSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            TitleLabel(title: "merchant.commercial_register".localized)

            InfoRowTrader(title: "merchant.cr_number".localized, value: viewModel.userModel?.trader?.commercial_register ?? "")

            RemoteImageView(imageUrl: viewModel.userModel?.trader?.commercial_register_image?.path ?? "")
                .scaledToFit()
                .frame(height: 140)
                .cornerRadius(12)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}

struct InfoRowTrader: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(addFont(fontType: .bold, size: 14))
                .foregroundColor(Color.SecondaryColor)
            Spacer()
            Text(value)
                .font(addFont(fontType: .Regular, size: 14))
                .foregroundColor(Color.CGray2)
        }
    }
}
