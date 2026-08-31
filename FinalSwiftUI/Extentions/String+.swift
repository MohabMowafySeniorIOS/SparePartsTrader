//
//  String+.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 24/12/2024.
//

import Foundation
extension String {
    var localized: String {
        print(self,Bundle.main)
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension String {
    func trimAllSpace() -> String {
           return components(separatedBy: .whitespacesAndNewlines).joined()
      }
      
      func trimSpace() -> String {
          return self.trimmingCharacters(in: .whitespacesAndNewlines)
      }
}
// MARK: - String Localization Helper

extension String {
    func localized(for language: String = Locale.current.languageCode ?? "en") -> String {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}
extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
extension String {
    func highlightKeyword() -> NSAttributedString {
      // var currenccccy = "¥"
        let attributed = NSMutableAttributedString(string: self)
//        if let range = self.range(of: currenccccy) {
//            let nsRange = NSRange(range, in: self)
//            attributed.addAttribute(.font, value: AppSARFont.Regular.size(20), range: nsRange)
//        }
        return attributed
    }
}
