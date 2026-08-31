//
//  LanguageSelectionView.swift
//  SparePartsTrader
//
//  Created by Mohab Mowafy on 21/06/2026.
//

import Foundation
import SwiftUI

// MARK: - Language Selection View

struct LanguageSelectionView: View {

    @EnvironmentObject var languageManager: LanguageManager
    var onLanguageSelected: () -> Void

    @State private var selectedLanguage: String = ""
    @State private var animateIn = false

    private let languages: [(code: String, imageName: String)] = [
        ("ar", "arabLang"),
        ("en", "enLang")
    ]

    var body: some View {
        ZStack {
            // ── White background ─────────────────────────────────────────
            Color.white.ignoresSafeArea()

            // ── Subtle top accent bar ────────────────────────────────────
            VStack {
                Rectangle()
                    .fill(Color.MainColor)
                    .frame(height: 4)
                Spacer()
            }
            .ignoresSafeArea(edges: .top)

            // ── Main content ─────────────────────────────────────────────
            VStack(spacing: 0) {

                Spacer()

                // Logo
                Image("languageLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 80)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : -20)
                    .animation(.easeOut(duration: 0.5), value: animateIn)

                Spacer().frame(height: 36)

                // Title
                VStack(spacing: 10) {
                    Text("اختر لغتك / Choose Language")
                        .font(.custom(AppFont.bold.rawValue, size: 22))
                        .foregroundColor(Color.SecondaryColor)
                        .multilineTextAlignment(.center)

                    Text("يمكنك تغيير اللغة لاحقاً من الإعدادات\nYou can change it later in Settings")
                        .font(.custom(AppFont.Regular.rawValue, size: 13))
                        .foregroundColor(Color.CGray2)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                }
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 15)
                .animation(.easeOut(duration: 0.5).delay(0.15), value: animateIn)

                Spacer().frame(height: 48)

                // Language cards
                HStack(spacing: 20) {
                    ForEach(languages, id: \.code) { lang in
                        LanguageCardView(
                            imageName: lang.imageName,
                            isSelected: selectedLanguage == lang.code
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedLanguage = lang.code
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.25), value: animateIn)

                Spacer().frame(height: 52)

                // Confirm button
                Button {
                    guard !selectedLanguage.isEmpty else { return }
                    
                    saveAndProceed()
                } label: {
                    Text(selectedLanguage == "ar" ? "تأكيد" : "Confirm")
                        .font(.custom(AppFont.bold.rawValue, size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(
                            selectedLanguage.isEmpty
                                ? Color.MainColor.opacity(0.4)
                                : Color.MainColor
                        )
                        .cornerRadius(26)
                        .shadow(
                            color: selectedLanguage.isEmpty ? .clear : Color.MainColor.opacity(0.35),
                            radius: 10, x: 0, y: 4
                        )
                }
                .disabled(selectedLanguage.isEmpty)
                .padding(.horizontal, 32)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.35), value: animateIn)

                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateIn = true
            }
        }
    }

    // MARK: - Save & Restart App

    private func saveAndProceed() {
        // 1. Apply language
        languageManager.currentLanguage = selectedLanguage

        // 2. Mark language screen as seen (never show again)
        Helper.SavehasSelectedLanguage(value: true)

        // 3. Restart the app UI so layout direction applies correctly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            // Post restart notification — RootView listens and rebuilds with new UUID
            Foundation.NotificationCenter.default.post(name: .restartAppForLanguage, object: nil)
        }
    }
}

// MARK: - Notification Name

extension Foundation.Notification.Name {
    static let restartAppForLanguage = Foundation.Notification.Name("restartAppForLanguage")
}

// MARK: - Language Card

private struct LanguageCardView: View {

    let imageName: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 68)

                Image(isSelected ? "selectIcon" : "unSelectICon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.MainColor.opacity(0.07) : Color.CGray1.opacity(0.4))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color.MainColor : Color.TextBorderColor,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .scaleEffect(isSelected ? 1.04 : 1.0)
            .shadow(
                color: isSelected ? Color.MainColor.opacity(0.15) : .clear,
                radius: 10, x: 0, y: 4
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    LanguageSelectionView {
        print("Language confirmed")
    }
    .environmentObject(LanguageManager())
}
