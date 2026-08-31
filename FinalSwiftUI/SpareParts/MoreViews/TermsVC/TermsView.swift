//
//  TermsView.swift
//  FinalSwiftUI
//
//  Created by Mohab on 17/05/2025.
//

import SwiftUI

struct TermsView: View {
    @Binding var isSelected : Bool
    @Binding var textColorChange: Bool
    var body: some View {
       
        HStack {
            if isSelected {
                Image.checkedIcon
                    .cornerRadius(5)
//                    .renderingMode(.template)
//                    .foregroundStyle(.main)
            }else{
                Image.unCheckedIcon
            }
            Text("Agreeing_to_the_terms_and_conditions".localized)
                .font(addFont(fontType: .Regular, size: 16))
                .foregroundStyle(textColorChange ? Color.CRed : Color.CBlack)
            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var selected = true
    @Previewable @State var textSelected = false
    TermsView(isSelected: $selected, textColorChange: $textSelected)
}
