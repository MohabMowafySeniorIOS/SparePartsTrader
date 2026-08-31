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
    @State var notificationCount: Int = 10
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
