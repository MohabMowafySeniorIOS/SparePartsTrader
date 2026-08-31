//
//  GifVC.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 04/12/2024.
//



import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let gifName: String
   
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let gifURL = URL(fileURLWithPath: gifPath)
            let request = URLRequest(url: gifURL)
            webView.load(request)
        }
        webView.scrollView.isScrollEnabled = false // Prevent scrolling
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct GifVC: View {
    @State private var showMainView = false
    var body: some View {
        
        if showMainView {
            SplashScreenView() // Transition to your main view
        } else {
            
            WebView(gifName: "Washer") // Replace "example" with your GIF file name (without extension)
                .frame(width: 300, height: 300)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showMainView = true
                }
            }
        }
       
    }
}

//struct GifVC: View {
//    var body: some View {
//        GIFPlayerView(gifName: "Washer") // Replace "example" with your GIF file name (without extension)
//            .frame(width: 300, height: 300)
//    }
//}
#Preview {
    GifVC()
}
