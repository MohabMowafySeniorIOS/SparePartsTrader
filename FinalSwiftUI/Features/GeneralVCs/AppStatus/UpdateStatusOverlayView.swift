//
//  UpdateStatusOverlayView.swift
//  FinalSwiftUI
//
//  Full-screen blocking view shown on top of the whole app whenever
//  AppStatusManager reports a "maintenance" or "update required" status.
//  The user cannot dismiss it or interact with anything behind it.
//

import SwiftUI

struct UpdateStatusOverlayView: View {
    let status: App_updated_enum

    private var iconName: String {
        switch status {
        case .updated: return "arrow.triangle.2.circlepath.circle.fill"
        case .under_maintainance: return "wrench.and.screwdriver.fill"
        }
    }

    private var title: String {
        switch status {
        case .updated: return "New update available!".localized
        case .under_maintainance: return "We're down for maintenance".localized
        }
    }

    private var description: String {
        switch status {
        case .updated:
            return "We're always working to make your experience better! Update now to keep using the app.".localized
        case .under_maintainance:
            return "We're fixing a small issue right now. The app will be back shortly, sorry for the trouble.".localized
        }
    }

    private var buttonTitle: String {
        switch status {
        case .updated: return "Update".localized
        case .under_maintainance: return "Close".localized
        }
    }

    var body: some View {
        ZStack {
            Color.CWhite
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.MainColor)

                VStack(spacing: 16) {
                    Text(title)
                        .font(addFont(fontType: .bold, size: 20))
                        .foregroundColor(.TitleColor)
                        .multilineTextAlignment(.center)

                    Text(description)
                        .font(addFont(fontType: .Regular, size: 15))
                        .foregroundColor(.DesColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Spacer()

                // Reuses the app's standard button, which is Color.MainColor by default.
                ContentButtonView(title: buttonTitle) {
                    handleTap()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .padding(16)
        }
        .transition(.opacity)
    }

    private func handleTap() {
        switch status {
        case .updated:
            if let url = URL(string: "https://apps.apple.com/app/\(AppStoreAppId)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .under_maintainance:
            exit(0)
        }
    }
}

#Preview {
    UpdateStatusOverlayView(status: .updated)
}
