//
//  ZoomableImageViewer.swift
//  SparePartsTrader
//
//  Created by Mohab Mowafy on 08/08/2026.
//

import Foundation
import SwiftUI

// MARK: - Full screen viewer for remote images

struct ZoomableImageViewer: View {

    @Binding var isPresented: Bool
    let imageUrls: [String]
    @State var selectedIndex: Int

    var body: some View {
        ZoomableViewerChrome(
            isPresented: $isPresented,
            selectedIndex: $selectedIndex,
            count: imageUrls.count
        ) {
            ForEach(Array(imageUrls.enumerated()), id: \.offset) { index, urlString in
                ZoomableContainer {
                    AsyncImage(url: URL(string: urlString)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .tint(.white)

                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)

                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.gray)
                                .padding(60)

                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .tag(index)
            }
        }
    }
}

// MARK: - Full screen viewer for local (already loaded) images

struct ZoomableLocalImageViewer: View {

    @Binding var isPresented: Bool
    let images: [UIImage]
    @State var selectedIndex: Int

    var body: some View {
        ZoomableViewerChrome(
            isPresented: $isPresented,
            selectedIndex: $selectedIndex,
            count: images.count
        ) {
            ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                ZoomableContainer {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .tag(index)
            }
        }
    }
}

// MARK: - Shared chrome (black backdrop, close button, page counter)

struct ZoomableViewerChrome<Pages: View>: View {

    @Binding var isPresented: Bool
    @Binding var selectedIndex: Int
    let count: Int
    @ViewBuilder var pages: () -> Pages

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            TabView(selection: $selectedIndex) {
                pages()
            }
            .tabViewStyle(.page(indexDisplayMode: count > 1 ? .automatic : .never))
            .ignoresSafeArea()

            VStack {
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.white)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    }

                    Spacer()

                    if count > 1 {
                        Text("\(selectedIndex + 1) / \(count)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.black.opacity(0.5)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

// MARK: - Pinch / double tap / pan behaviour

struct ZoomableContainer<Content: View>: View {

    @ViewBuilder var content: () -> Content

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 5.0

    var body: some View {
        GeometryReader { proxy in
            content()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    SimultaneousGesture(magnification, panning(in: proxy.size))
                )
                .onTapGesture(count: 2) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        if scale > minScale {
                            resetZoom()
                        } else {
                            scale = 2.5
                            lastScale = 2.5
                        }
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .onDisappear { resetZoom() }
    }

    // MARK: Gestures

    private var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let newScale = lastScale * value
                scale = min(max(newScale, minScale), maxScale)
            }
            .onEnded { _ in
                if scale <= minScale {
                    withAnimation(.easeInOut(duration: 0.2)) { resetZoom() }
                } else {
                    lastScale = scale
                }
            }
    }

    private func panning(in size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard scale > minScale else { return }
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                guard scale > minScale else { return }
                let maxX = (size.width * (scale - 1)) / 2
                let maxY = (size.height * (scale - 1)) / 2

                withAnimation(.easeInOut(duration: 0.2)) {
                    offset = CGSize(
                        width: min(max(offset.width, -maxX), maxX),
                        height: min(max(offset.height, -maxY), maxY)
                    )
                }
                lastOffset = offset
            }
    }

    private func resetZoom() {
        scale = minScale
        lastScale = minScale
        offset = .zero
        lastOffset = .zero
    }
}
