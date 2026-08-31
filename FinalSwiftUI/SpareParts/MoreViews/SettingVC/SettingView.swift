//
//  SettingView.swift
//  FinalSwiftUI
//
//  Created by Mohab on 19/05/2025.
//

import SwiftUI



struct SettingsView: View {
   
    @State private var notificationsEnabled = true
    @EnvironmentObject var languageManager: LanguageManager
    @State private var selectedLanguage: SelectedLanguage = .en
    
    
    @ObservedObject var coordiantor: MainCoordinator
    init(coordinator: MainCoordinator) {
        _coordiantor = ObservedObject(wrappedValue: coordinator)
    }

    var body: some View {
        VStack {
            AppHeaderView(Title: "Settings".localized) {
                coordiantor.path.removeLast()
            }
            Spacer().frame(height: 80)
            Image("SettingIcon")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            Spacer().frame(height: 30)
            selectNotificationView
            Spacer().frame(height: 20)
            selectLanguageView
            Spacer().frame(height: 30)
            saveButton
            Spacer()
        }.background(
            Color(Color.backGroundColor)
        )
        
        .onAppear {
            selectedLanguage = languageManager.currentLanguage == "ar" ? .ar : .en
        }
    }
    
    private var selectNotificationView: some View {
        // Notification Toggle
        HStack {
            Text("Notifications".localized)
                .font(addFont(fontType: .bold, size: 14))
            Spacer()
            HStack {
                Text("Enabled")
                settingRadioButton(isSelected: notificationsEnabled)
                    .onTapGesture {
                        notificationsEnabled = true
                    }

                Text("Disable")
                settingRadioButton(isSelected: !notificationsEnabled)
                    .onTapGesture {
                        notificationsEnabled = false
                    }
            }
        }
        .padding(.horizontal)
    }
    
    private var selectLanguageView: some View {
        HStack {
            Text("Language".localized)
                .font(addFont(fontType: .bold, size: 14))
            Spacer()
            HStack {
                Text("Arabic".localized)
                settingRadioButton(isSelected: selectedLanguage == .ar)
                    .onTapGesture {
                        selectedLanguage = .ar
                    }

                Text("English".localized)
                settingRadioButton(isSelected: selectedLanguage == .en)
                    .onTapGesture {
                        selectedLanguage = .en
                    }
            }
        }
        .padding(.horizontal)
    }
    
    private var saveButton: some View {
        ContentButtonView(title: "Save".localized) {
            let languageCode = selectedLanguage == .en ? "en" : "ar"
            languageManager.currentLanguage = languageCode
            SessionEvents.shared.unauthorized.send(())
        }
        .padding(40)
    }
}


struct settingRadioButton: View {
    var isSelected: Bool
    var body: some View {
        isSelected  ? (Image.selectIcon.frame(width: 16, height: 16)) : (Image.unSelectICon.frame(width: 16, height: 16))
    }
}

// Custom TabBar Item
struct TabBarItem: View {
    var title: String
    var systemImage: String

    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .font(.system(size: 20))
            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

