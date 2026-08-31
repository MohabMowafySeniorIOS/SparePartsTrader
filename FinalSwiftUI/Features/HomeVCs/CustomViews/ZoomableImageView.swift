//
//  ZoomableImageView.swift
//  MyAuctions
//
//  Created by Mohab on 25/06/2025.
//
import SwiftUI


struct ZoomableImageView: View {
    @Binding var scale: CGFloat

    @Environment(\.dismiss) var dismiss
    var image: Image

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.CRed)
                    .font(addFont(fontType: .bold, size: 20))
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            }
            .padding()

            image
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .gesture(
                    // Pinch to zoom
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value.magnitude
                        }
                        .onEnded { _ in
                            if scale < 1 {
                                scale = 1
                            }
                        }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

        }
        .background(Color.clear)
        .edgesIgnoringSafeArea(.all)
    }
}
