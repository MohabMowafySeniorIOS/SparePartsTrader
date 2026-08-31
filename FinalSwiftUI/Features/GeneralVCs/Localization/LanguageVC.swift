//
//  LanguageVC.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 27/12/2024.
//

import SwiftUI

// MARK: - Language Enum

enum Language: String, CaseIterable {
    case english = "en"
    case arabic = "ar"

    var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic:  return "العربية"
        }
    }
}

// MARK: - Language Selection View

struct SelectLanguageVC: View {
    // MARK: - Localization Keys

    private let langTitle     = "language_title".localized
    private let saveBtnTitle  = "save_button".localized

    // MARK: - AppStorage Language

    @AppStorage("selectedLanguage") private var selectedLanguage: String = Language.english.rawValue

    // MARK: - UI State

    @State private var arImageTitle = AssetImage.arabLang
    @State private var arSelected   = true

    @State private var enImageTitle = AssetImage.enLang
    @State private var enSelected   = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            Image.languageLogo
                .resizable()
                .frame(width: 96, height: 96)

            Spacer()

            VStack(spacing: 56) {
                HStack {
                    Image.globalIcon
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text(langTitle)
                        .font(.headline)
                }

                HStack(spacing: 35) {
                    LanguageSelectView(imageName: $arImageTitle, isSelect: $arSelected)
                        .onTapGesture {
                            arSelected = true
                            enSelected = false
                        }

                    LanguageSelectView(imageName: $enImageTitle, isSelect: $enSelected)
                        .onTapGesture {
                            arSelected = false
                            enSelected = true
                        }
                }

                ContentButtonView(title: saveBtnTitle) {
                    selectedLanguage = arSelected ? Language.arabic.rawValue : Language.english.rawValue
                }
            }

            Spacer()
        }
        .padding()
        .environment(\.layoutDirection, selectedLanguage == Language.arabic.rawValue ? .rightToLeft : .leftToRight)
    }
}



// MARK: - Preview

#Preview {
    SelectLanguageVC()
}
