//
//  ValidationView.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//

import Foundation

import SwiftUI

struct CustomValidationView: View {
    @State private var showToast = false
    @Binding private var toastMessage :String
        @State private var toastColor: Color = .green // Default to green (success)
        
        var body: some View {
            VStack {
                Button("Show Success Toast") {
                    showToastWithMessage(message: "Operation Successful!Operation Successful!Operation Successful!Operation Successful!Operation Successful!Operation Successful!Operation Successful!Operation Successful!Operation Successful!Operation Successful!Operation Successful!", color: .green)
                }
                .padding()
                
                Button("Show Error Toast") {
                    showToastWithMessage(message: "Something went wrongOperation Successful!Operation Successful!Operation Successful!Operation Successful!Operation Successful!Operation Successful!!", color: .red)
                }
                .padding()

                Spacer()
            }.frame(maxWidth: .infinity)
            .overlay(
                Group {
                    if showToast {
                        ToastView(message: toastMessage, backgroundColor: toastColor)
                            .transition(.move(edge: .top))
                            .zIndex(1) // To make sure the toast is above other content
                    }
                }.frame(maxWidth: .infinity)
            ).frame(maxWidth: .infinity)
            .onAppear {
                // You can add a delay to auto-hide the toast
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showToast = false
                    }
                }
            }
        }
        
        // Function to show the toast with the provided message and color
        func showToastWithMessage(message: String, color: Color) {
            toastMessage = message
            toastColor = color
            showToast = true
            
            // Auto-hide toast after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showToast = false
                }
            }
        }
}
struct ToastView: View {
    let message: String
    let backgroundColor: Color
    var duration: Double = 2.5   // ⏱️ وقت الاختفاء
    @State private var isVisible = true
    
    var body: some View {
        if isVisible {
            VStack {
                
                HStack {
                    
                    Text(message)
                        .font(.body)
                        .padding()
                        .foregroundColor(.white)
                        .background(backgroundColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity) // This ensures full screen wi
                    //   .padding(.horizontal, 20)
                }
                
                Spacer()
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
        }
       
       
       
    }
}
// Model for parsing the response
struct Post: Codable {
    let title: String
    let body: String
}


