//
//  OfferImagesViewPopup.swift
//  SpareParts
//
//  Created by Mohamed Elboraey on 13/02/2026.
//

import SwiftUI

struct OfferImagesViewPopup: View {
    @Binding var isPresented: Bool
    let images: [OrderImage]
    @State private var showFullScreen = false
    @State private var selectedImageIndex = 0
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private var imageUrls: [String] {
        images.compactMap { $0.path }
    }

    var body: some View {

        ZStack {

            // MARK: - Background Dim
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
            }

            // MARK: - Bottom Sheet
            if isPresented {
                VStack {
                    Spacer()

                    content
                        .transition(.scale)
                        .animation(.easeInOut, value: isPresented)

                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            ZoomableImageViewer(
                isPresented: $showFullScreen,
                imageUrls: imageUrls,
                selectedIndex: selectedImageIndex
            )
        }
    }
    
    private var content: some View {
        VStack(spacing: 20) {
            
            ZStack {
                Text("Images of added part".localized)
                    .font(.headline)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
            }
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, stringUrl in
                        if let url = URL(string: stringUrl.path ?? "") {
                            AsyncImage(url: url)
                                .scaledToFit()
                                .frame(width: 165, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .contentShape(RoundedRectangle(cornerRadius: 16))
                                .onTapGesture {
                                    selectedImageIndex = index
                                    showFullScreen = true
                                }
                        }
                    }
                }
            }
        }
        .frame(height: 360)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .ignoresSafeArea(edges: .bottom)
        )
        .padding(.horizontal)
    }
    private func dismiss() {
        isPresented = false
    }
}

struct ItemsImagesViewPopup: View {
    @Binding var isPresented: Bool
    let images: [AttachMentModel?]
    @State private var showFullScreen = false
    @State private var selectedImageIndex = 0
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private var imageUrls: [String] {
        images.compactMap { $0?.path }
    }

    var body: some View {

        ZStack {

            // MARK: - Background Dim
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
            }

            // MARK: - Bottom Sheet
            if isPresented {
                VStack {
                    Spacer()

                    content
                        .transition(.scale)
                        .animation(.easeInOut, value: isPresented)

                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            ZoomableImageViewer(
                isPresented: $showFullScreen,
                imageUrls: imageUrls,
                selectedIndex: selectedImageIndex
            )
        }
    }
    
    private var content: some View {
        VStack(spacing: 20) {
            
            ZStack {
                Text("Images of added part".localized)
                    .font(.headline)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
            }
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        RemoteImageView(imageUrl: image?.path ?? "")
                            .frame(width: 165, height: 150)
                            .clipped()
                            .cornerRadius(12)
                            .contentShape(RoundedRectangle(cornerRadius: 12))
                            .onTapGesture {
                                selectedImageIndex = index
                                showFullScreen = true
                            }
                    }
                }
            }
        }
        .frame(height: 360)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .ignoresSafeArea(edges: .bottom)
        )
        .padding(.horizontal)
    }
    private func dismiss() {
        isPresented = false
    }
}

//#Preview {
//    OfferImagesViewPopup(isPresented: true, images: [])
//}
