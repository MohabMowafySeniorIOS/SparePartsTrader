//
//  MessageView.swift
//  FinalSwiftUI
//
//  Created by Mohab on 17/05/2025.
//

import SwiftUI

struct MessageCell: View {
    var body: some View {
        HStack {
            Text("مزاد سيارت")
            Spacer()
            HStack{
                Text("محمد ناصر")
                Image.profileImage
            }
        }
        .frame(height: 42)
        .padding(16)
        
            .background(Color.BgView)
           
        
    }
}

#Preview {
    MessageCell()
}
