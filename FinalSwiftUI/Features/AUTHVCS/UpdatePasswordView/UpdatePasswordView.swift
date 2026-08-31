//
//  EnterPhoneNumberView.swift
//  Auctions
//
//  Created by Mohab on 02/06/2025.
//

import SwiftUI

struct UpdatePasswordView: View {
    
    @ObservedObject private var viewModel: UpdatePasswordViewModel
    init(viewModel: UpdatePasswordViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
 
    @State var passText: String = ""
    @State var confirmPassText: String = ""
   
    @State var validationLabel: String = ""
    @State var isValidationLabel: Bool = false
    @State var isSelected: Bool = false
    @State var showTitle: Bool = false
   
    var body: some View {
        ShowViewState(state: viewModel.state) { Model in
            mainContent .background(
                Color(Color.backGroundColor)
            )
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack {
            headerView
            scrollView
        }
    }
    
    private var headerView: some View {
        AuthHeaderView(Title: "") {
            viewModel.disMiss()
        }
    }
    
    private var scrollView: some View {
        ScrollView{
            VStack{
                headerView2
                textFields
                confirmButtons
            }
        }
    }
    
    @ViewBuilder
    private var headerView2: some View {
        Image("languageLogo")
            .resizable()
            .scaledToFill()
            .frame(width: 150,height: 120)
       
        
      
        Text("Change_Password".localized)
            .padding(.bottom,40)
    }
    
    @ViewBuilder
    private var textFields: some View {
        CustomePasswordTF(text: $passText, title_label: "", Validation_label: $validationLabel, is_validation_label: $isValidationLabel, isSelectable: isSelected, showTitle: showTitle, placeholder: "enter_old_password".localized)
            .padding(.horizontal)
        
        CustomePasswordTF(text: $confirmPassText, title_label: "", Validation_label: $validationLabel, is_validation_label: $isValidationLabel, isSelectable: isSelected, showTitle: showTitle, placeholder: "enter_new_password".localized)
            .padding(.horizontal)
    }
    
    private var confirmButtons: some View {
        //"confirm"
        ContentButtonView(title: "confirm".localized) {
            viewModel.ChangePassword(parameters: .init(current_password:passText, password: confirmPassText, method: "PUT"))
        }
        .padding()
        .padding(.top,50)
        .padding(.horizontal,25)
    }
    
}

