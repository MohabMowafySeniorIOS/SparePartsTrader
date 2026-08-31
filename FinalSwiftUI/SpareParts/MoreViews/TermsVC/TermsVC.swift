//
//  TermsView.swift
//  FinalSwiftUI
//
//  Created by Mohab on 17/05/2025.
//

import SwiftUI
enum TermsTyoe {
    case About
    case Terms
    case Privacy
    case Policy
}
struct TermsVC: View {
    @State private var rotation: Double = 0
    @State private var isLoading = true
    var pageTitle: String?
    @ObservedObject private var viewModel: TermsViewModel
    init(pageTitle: String ,viewModel: TermsViewModel) {
        self.pageTitle = pageTitle
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
     var body: some View {
         VStack {
            headerView
             ShowViewState(state: viewModel.state) { Model in
                 mainContent
             }
            
             .onAppear{
                    viewModel.getTerms(tailUrl: pageTitle ?? "")
             }
             
             Spacer()
         } .background(
            Color(Color.backGroundColor)
         )
        
      
    }
    
    private var headerView: some View {
        AppHeaderView(Title: viewModel.pageTitle ?? "") {
            viewModel.disMiss()
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        
        ScrollView {
            
            VStack(spacing:16) {
                
                VStack(spacing: 16) {
                    Image.TermsImage
                  
                    Text((viewModel.content ?? "").removingHTMLTags)  .font(addFont(fontType: .Regular, size: 14))
                   
                  
                }.padding()
               
            }

        }
        
        .mask(RoundedRectangle(cornerRadius: 0))
       
    }
    
}
extension String {
    var removingHTMLTags: String {
        replacingOccurrences(of: "<[^>]+>",
                             with: "",
                             options: .regularExpression)
    }
}
#Preview {
  //  TermsVC()
}

extension String {
    var htmlToPlainText: String {
        guard let data = self.data(using: .utf8) else { return self }
        
        if let attributed = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return attributed.string
        }
        return self
    }
}
import SwiftUI
import WebKit

struct HTMLWebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
