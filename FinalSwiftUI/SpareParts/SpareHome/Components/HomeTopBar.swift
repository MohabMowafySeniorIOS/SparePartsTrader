//
//  HomeTopBar.swift
//  MyAuctions
//
//  Created by Mohab on 10/07/2025.
//
import SwiftUI


struct HomeTopBar: View {

    var userName: String
    var notificationAction: (()->Void)
    var notificationCount: Int = 0
    var body: some View {
        ZStack {

            HStack {
                Text("Hello".localized + " " + userName)
                    .foregroundStyle(Color.CWhite)
                    .lineLimit(2)                 // يمنع النزول سطر تاني
                  //  .truncationMode(.tail)        // يحط ... لو النص طويل

                Spacer(minLength: 200)

                Image(systemName: "bell.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .overlay(alignment: .topTrailing) {
                        if notificationCount > 0 {
                            Text(notificationCount > 99 ? "99+" : "\(notificationCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color.CWhite)
                                .padding(.horizontal, 5)
                                .frame(minWidth: 18, minHeight: 18)
                                .background(
                                    Capsule().fill(Color.CRed)
                                )
                                .overlay(
                                    Capsule().stroke(Color.CWhite, lineWidth: 1.5)
                                )
                                .offset(x: 10, y: -8)
                        }
                    }
                    .onTapGesture {
                        notificationAction()
                    }
            }
            

//            Circle()
//                .fill(Color.CWhite)
//                .frame(width: 50, height: 50)
//                .overlay {
//                    Text("LOGO")
//                        .foregroundStyle(Color.CBlack)
//                }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.MainColor)
    }
}
