//
//  PaymentWebView.swift
//  SpareParts
//
//  Created by Mohab on 20/02/2026.
//

import Foundation
import SwiftUI
import WebKit

enum PaymentStatusEnum {
    case success
    case failure
}

struct PaymentScreen: View {
    
    let paymentURL: String
    @State var paymentStatus: PaymentStatusEnum?
    
    @ObservedObject var viewModel: PaymentWebViewModel
    init(viewModel: PaymentWebViewModel, url: String) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.paymentURL = url
    }
    
    var body: some View {
        VStack {
            AppHeaderView(Title: "Payment".localized) {
                viewModel.coordinator.disMiss()
            }
            if let url = URL(string: paymentURL) {
                PaymentWebView(paymentStatus: $paymentStatus, url: url)
                    .ignoresSafeArea()
            }
            
            Spacer()
        }
        .onChange(of: paymentStatus) { newValue in
            guard let status = newValue else { return }
            switch status {
            case .success:
                viewModel.paymentSuccess()
            case .failure:
                viewModel.state = .error("Payment Failed")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.viewModel.paymentSuccess()
                }
                
            }
        }
    }
}

struct PaymentWebView: UIViewRepresentable {
    @Binding var paymentStatus: PaymentStatusEnum?
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.bounces = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(paymentStatus: $paymentStatus)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var paymentStatus: PaymentStatusEnum?
        init(paymentStatus: Binding<PaymentStatusEnum?>) {
            self._paymentStatus = paymentStatus
            super.init()
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Page loaded")
        }
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            if let url = navigationAction.request.url?.absoluteString {
                print("Navigating to:", url)
                
                // هنا تقدر تمسك success / failed URL
                if url.contains("status=success") {
                    paymentStatus = .success
                }
                
                if url.contains("status=fail") {
                    paymentStatus = .failure
                }
            }
            
            decisionHandler(.allow)
        }
    }
}
