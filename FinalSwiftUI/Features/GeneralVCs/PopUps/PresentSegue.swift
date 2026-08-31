//
//  PresentSegue.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//

import SwiftUI

import SwiftUI

struct PresentSegue: View {
    @State private var isFullScreenPresented = false

       var body: some View {
           VStack {
               Button("Present Full Screen Modal") {
                   isFullScreenPresented.toggle()  // Trigger full screen modal
               }
               .padding()

               // Full-screen modal presentation
               .fullScreenCover(isPresented: $isFullScreenPresented) {
                   FullScreenView(isDismiss: $isFullScreenPresented)
               }
           }
           .navigationTitle("First View")
       }
   }


struct FullScreenView: View {
    @Binding var isDismiss :Bool
    var body: some View {
        
        VStack {
            Text("This is a full-screen modal!")
                .font(.largeTitle)
                .padding()

            Button("Dismiss") {
                isDismiss = false
                // Manually dismiss the modal by setting state to false
            }
            .padding()

        }
        .background(Color.blue.opacity(0.1))  // Just to show the background
        .edgesIgnoringSafeArea(.all)  // Ignore safe area for full-screen effect
        .onTapGesture {
            // Dismiss the full screen modal when tapping
            // You can dismiss by setting the state variable controlling the modal
        }
    }
}

#Preview {
    PresentSegue()
}
