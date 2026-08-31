//
//  OnBoardingVC.swift
//  SpareParts
//
//  Created by Mohab on 06/03/2026.
//

import Foundation
import SwiftUI

struct OnboardingView: View {

    @ObservedObject var viewModel: OnBoardingViewModel
    init(viewModel: OnBoardingViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    @State private var index = 0

    var body: some View {

        VStack {

            HStack {
                Spacer()

                Button("Skip".localized) {
                    finishOnboarding()
                }.foregroundColor(Color.MainColor)
            }
            .padding(.horizontal)

            TabView(selection: $index) {

                ForEach(Array(onboardingData.enumerated()), id: \.offset) { i, item in

                    OnboardingPage(item: item)
                        .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            ContentButtonView(title: index == onboardingData.count - 1 ? "Start".localized : "Next".localized) {
                if index < onboardingData.count - 1 {
                    index += 1
                } else {
                    finishOnboarding()
                }
            }
            .padding(.horizontal)
            .padding(.horizontal)


        }
    }

    func finishOnboarding() {
        viewModel.showAuth()
    }
}
struct OnboardingItem: Identifiable {
    let id = UUID()
    
    let image: String
    let title: String
    let desc: String
}
let onboardingData: [OnboardingItem] = [
   
    
    OnboardingItem(
        image: "on1",
        title: "Expand Your Sales with Drivak.⁠".localized,
        desc: "Receive daily spare parts requests from customers across Saudi Arabia and grow your business effortlessly.⁠".localized
    ),

    OnboardingItem(
        image: "on2",
        title: "Send Quotes in Seconds.".localized,
        desc: "View parts requests with VIN numbers and photos, then send competitive quotes with warranty and shipping options instantly.".localized
    ),

    OnboardingItem(
        image: "on3",
        title: "Smart Management & Guaranteed Profits",
        desc: "Track accepted quotes, manage shipments, and withdraw your earnings securely through an intuitive dashboard."
    )
]


struct OnboardingPage: View {

    let item: OnboardingItem
    var body: some View {
        VStack(spacing: 20) {

            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 220)

            Text(item.title.localized)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(item.desc.localized)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
