//  AddPieceView.swift
//  MyAuctions
//  Created by Mohab Mowafy on 17/07/2025.

import SwiftUI

enum RequiredPieceType: String {
    case original = "new_original"
    case wekala = "new_agency"
    case usedLocal = "used_local"
    case usedForeign = "used_import"
}

struct AddPieceView: View {
    @Environment(\.dismiss) var dismiss
    @Binding  var partsPiece: [PartModel]
    @State private var pieceNameFieldText: String = ""
    @State private var isPieceNameFieldValid: Bool = true
    @State private var pieceNumFieldText: String = ""
    @State private var isPieceNumFieldValid: Bool = true
    @State private var pieceCountFieldText: String = ""
    @State private var isPieceCountFieldValid: Bool = true
    @State private var pickedImages: [UIImage] = []
    @State private var showImagePicker: Bool = false
    @State private var isImagePickerValid: Bool = true
    @State private var requiredPieceType: RequiredPieceType = .original
    @State private var descriptionText: String = ""
    @State private var isDescribtionFieldValid: Bool = true
    
    @ObservedObject private var viewModel: AddPieceViewModel
    
    init(viewModel: AddPieceViewModel, partsPiece: Binding<[PartModel]>) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._partsPiece = partsPiece
    }
    
    var body: some View {
        
        mainContent
            .navigationBarHidden(true)
        
    }
    
    var mainContent: some View {
        VStack {
           
            
            AppHeaderView(Title: "add_piece_title".localized) {
                dismiss()
            }
            ShowViewState(state: viewModel.state) { Model in
                VStack {
                    scrollView
                    addPieceButton
                }
            }
            
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(onImagesPicked: { image in
                let maxImages = 4
                if pickedImages.count < maxImages {
                    pickedImages.append(contentsOf: image)
                }
            })
        }
    }
    
    var scrollView: some View {
      
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                textFields
                peiceImages
                pieceType
                describtionView
            }
        }
        .padding(.horizontal)

    }
    
    @ViewBuilder
    var textFields: some View {
        
            SpareTextFieldWithLabel(
                text: $pieceNameFieldText,
                is_validation_label: $isPieceNameFieldValid,
                is_title_label: true, fieldtype: .constant(.pieceName))

            SpareTextFieldWithLabel(
                text: $pieceNumFieldText,
                is_validation_label: $isPieceNumFieldValid,
                is_title_label: true, fieldtype: .constant(.PieceNum))

            SpareTextFieldWithLabel(
                text: $pieceCountFieldText,
                is_validation_label: $isPieceCountFieldValid,
                is_title_label: true, fieldtype: .constant(.pieceCount))
    }
   
    @ViewBuilder
    private var pieceType: some View {
        TitleLabel(title: "required_piece_type".localized)

        HStack {
            SelectorBarCustomView(
                title: "new (original)".localized,
                isSelected: requiredPieceType == .original
            )
            .onTapGesture {
                requiredPieceType = .original
            }
           
            
            SelectorBarCustomView(title: "new (wekala)".localized, isSelected: requiredPieceType == .wekala)
                .onTapGesture {
                     requiredPieceType = .wekala
                }
        }
        SelectorBarCustomView(title: "used (local)".localized, isSelected: requiredPieceType == .usedLocal)
            .onTapGesture {
                requiredPieceType = .usedLocal
            }
        
        SelectorBarCustomView(title: "user (foreign)".localized, isSelected: requiredPieceType == .usedForeign)
            .onTapGesture {
                requiredPieceType = .usedForeign
            }
    }
    
    @ViewBuilder
    private var peiceImages: some View {
        HStack {
            TitleLabel(title: "add_piece_images".localized)
            Spacer()
            Image(systemName: "photo.on.rectangle.angled.fill")
                .foregroundStyle(Color.MainColor)
                .onTapGesture {
                    showImagePicker = true
                }
        }

        ImagePickerAndSlider(pickedImages: $pickedImages,is_validation_label: $isImagePickerValid, onClose: {
            
        })
    }
    
    @ViewBuilder
    private var describtionView: some View {
        TitleLabel(title: "add_text_description".localized)
        
        VStack(spacing: 8) {
            TextEditor(text: $descriptionText)
                .frame(height: 100)
                .padding(8)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.CWhite)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemTeal), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                .padding(1)
                .multilineTextAlignment(.trailing)
                .environment(\.layoutDirection, .rightToLeft)
            
            if !isDescribtionFieldValid {
                HStack{
                    Text("Please Insert Describtion".localized)
                        .font(addFont(fontType: .bold, size: 12))
                        .foregroundStyle(Color.CRed)
                    
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private var addPieceButton: some View {
        SimpleSpareButton(buttonTitle: "add_piece".localized, action: {
            if isValid(){
                partsPiece.append(PartModel(name: pieceNameFieldText, number: pieceNumFieldText, type: requiredPieceType.rawValue, quantity: pieceCountFieldText, describtion: descriptionText, pickedImages: pickedImages))
                dismiss()
            }
           
        }, widthValue: 300, heightValue: 45)
        .padding(.top)
    }
   
    func isValid() -> Bool {
        var x: Bool = true
        FieldChecker(text: pieceNameFieldText, chVar: &x, labelHidden: &isPieceNameFieldValid)
        FieldChecker(text: pieceNumFieldText, chVar: &x, labelHidden: &isPieceNumFieldValid)
        FieldChecker(text: pieceCountFieldText, chVar: &x, labelHidden: &isPieceCountFieldValid)
        
        FieldChecker(text: descriptionText, chVar: &x, labelHidden: &isDescribtionFieldValid)
        
        if pickedImages.count == 0 {
            x = false
            isImagePickerValid = false
        }else {
            isImagePickerValid = true
        }
      
       
        return x
    }
}

