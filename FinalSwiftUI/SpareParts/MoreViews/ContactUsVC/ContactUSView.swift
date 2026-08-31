//
//  ContentView.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 27/11/2024.
//

import SwiftUI

struct ContactUSView: View {
 
    @ObservedObject private var viewModel: contactUsViewModel
    init(viewModel: contactUsViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    @State private var selectedType: MessageType = .suggestion
    @State private var messageInput: String = ""
    @State private var ismMssageInputFieldValid: Bool = true
    @State private var messageBody : String = ""
    @State private var isMessageBodyFieldValid: Bool = true
    
    @State private var isOpened: Bool = true
    @State private var isComplain: Bool = false
   
    @State private var showSuccess = false
    var body: some View {
        
        ZStack {
                  
            contetntView
                  
            if let message = viewModel.state.data {
                      
                      Color.black.opacity(0.4)
                          .ignoresSafeArea()
                      
                SuccessPopupView(message: message ?? "", onClose: {
                    viewModel.coordinator.disMiss()
                })
                          .transition(.scale)
                  }
              }
              .animation(.easeInOut, value: showSuccess)
       
      

    }
    
    private var contetntView: some View {
        VStack {
            AppHeaderView(Title: "Contact Us".localized) {
                viewModel.disMiss()
            }
            Spacer()
            ShowViewState(state: viewModel.state) { Model in
                    
                 
                        mainContent
                   
            }
            Spacer()
        }.background(
            Color(Color.backGroundColor)
        )
    }
   
   
    // MARK: - Main Content
    
    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 16) {
                messageType
                textField
                textView
                saveButton
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var messageType: some View {
        HStack {
            Text("Message_Type".localized)
                .font(addFont(fontType: .bold, size: 12))
            Spacer()
        }

        HStack(spacing: 16) {
            SelectedCustomView(isSelected: $isOpened, title: "Opened".localized) {
                isOpened = true
                isComplain = false
            }
            
            SelectedCustomView(isSelected: $isComplain, title: "Complaint".localized) {
                isComplain = true
                isOpened = false
                
            }
        }
    }
    
    private var textField: some View {
        VStack(alignment: .trailing, spacing: 8) {
            CustomTextField(text: $messageInput, Validation_label: .constant("Please Inser Message Title".localized), is_validation_label: $ismMssageInputFieldValid, is_title_label: true, textType: .messageType)
        }
    }
    
    private var textView: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                Text("Message_Text".localized)
                    .font(addFont(fontType: .bold, size: 12))
                Spacer()
            }
            
            TextEditor(text: $messageBody)
                .frame(height: 120)
                .scrollContentBackground(.hidden)   // مهم
                    .background(Color.CWhite)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
            
            
            if !isMessageBodyFieldValid {
                HStack{
                    Text("Please Insert Message Text".localized)
                        .font(addFont(fontType: .bold, size: 12))
                        .foregroundStyle(Color.CRed)
                    
                    Spacer()
                }
            }
        }
    }
    
    private var saveButton: some View {
        ContentButtonView(title: "send".localized) {
            if isValid(){
                viewModel.sendMessage(parameters: .init(type: selectedType == .suggestion ? "Suggested" : "complaint",title: messageInput,content: messageBody))
            }
          
        }
    }
    
    func isValid() -> Bool {
        var x: Bool = true
        FieldChecker(text: messageInput, chVar: &x, labelHidden: &ismMssageInputFieldValid)
        FieldChecker(text: messageBody, chVar: &x, labelHidden: &isMessageBodyFieldValid)
       
        return x
    }
}

enum MessageType {
    case suggestion, complaint
}


