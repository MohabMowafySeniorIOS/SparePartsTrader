//
//  LAnguageSelectView.swift
//  FinalSwiftUI
//
//  Created by Mohab on 16/05/2025.
//

import SwiftUI

struct LanguageSelectView: View {
    
    @Binding var imageName : String
    @Binding var isSelect : Bool
    var body: some View {
        HStack(spacing:14) {
            Image(imageName)
            Image(isSelect ? "selectIcon":"unSelectICon")
        }
    }
}

//#Preview {
////    @State private var imageNameresorce = "arabLang"
////    LAnguageSelectView(imageName: $imageNameresorce)
//}
