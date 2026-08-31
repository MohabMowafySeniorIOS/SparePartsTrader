//
//  NavigationSegue.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//

import SwiftUI

import SwiftUI

struct NavigationSegue: View {
   
    
    var body: some View {
        NavigationView {
            VStack {
                // Button to trigger the segue-like behavior
                NavigationLink(destination: SecondView()) {
                    Text("Go to Second View")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .navigationTitle("First View")
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Text("You are in the second view!")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Second View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSegue()
    }
}
