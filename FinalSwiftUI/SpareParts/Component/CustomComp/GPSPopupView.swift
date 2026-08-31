//
//  GPSPopupView.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 17/07/2025.
//


import SwiftUI

struct GPSPopupView: View {
    
    let onActivate: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("يجب عليك تفعيل الـ GPS لتحديد المسافة")
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .padding()

            HStack(spacing: 16) {
                Button(action: onCancel) {
                    Text("إلغاء")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }

                Button(action: onActivate) {
                    Text("تفعيل")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal)
        }
        .padding(5)
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 20)
        .padding()
    }
}

#Preview(body: {
    GPSPopupView(onActivate: { }, onCancel: { })
})
