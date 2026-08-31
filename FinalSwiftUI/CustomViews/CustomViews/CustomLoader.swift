//
//  CustomLoader.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//

import SwiftUI


struct LoaderView: View {
    @Binding  var rotation: Double
    @Binding  var isLoading : Bool

    var body: some View {
        VStack {
            if isLoading {
                CustomLoader()
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            // Start animation when the view appears
            startLoadingAnimation()
        }
    }
    
    // Custom Loader
    func CustomLoader() -> some View {
        ZStack {
            Text("Loading".localized)
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.3)
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .trim(from: 0, to: 0.75)
                        .stroke(
                            AngularGradient(gradient: Gradient(colors: [.blue, .green]), center: .center),
                            lineWidth: 8
                        )
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                            value: rotation
                        )
                )
        }
        
    }
    
    func startLoadingAnimation() {
        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            rotation += 360
        }
    }
}
#Preview {
    LoaderView(rotation: .constant(0), isLoading: .constant(true))
}
