//
//  PopUpExample.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//

import SwiftUI

struct BottomPopupView: View {
    @State private var showPopup = false

    var body: some View {
        ZStack {
            // Main Content
            VStack {
                Text("Main Content")
                    .font(.largeTitle)
                    .padding()
                
                Button(action: {
                    withAnimation {
                        showPopup.toggle()
                    }
                }) {
                    Text(showPopup ? "Hide Popup" : "Show Popup")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            // Bottom Popup
            if showPopup {
                VStack {
                    Spacer()
                    VStack {
                        Text("This is a bottom popup")
                            .font(.headline)
                            .padding()
                        Text("This is a bottom popup")
                            .font(.headline)
                            .padding()
                        Text("This is a bottom popup")
                            .font(.headline)
                            .padding()
                        Text("This is a bottom popup")
                            .font(.headline)
                            .padding()
                        Text("This is a bottom popup")
                            .font(.headline)
                            .padding()
                        Text("This is a bottom popup")
                            .font(.headline)
                        
                            .padding()
                        Divider()
                        Button(action: {
                            withAnimation {
                                showPopup = false
                            }
                        }) {
                           
                            Text("Close")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .background(Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all))
    }
}

struct BottomPopupView_Previews: PreviewProvider {
    static var previews: some View {
        BottomPopupView()
    }
}
