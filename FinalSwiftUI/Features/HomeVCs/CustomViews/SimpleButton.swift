import SwiftUI

struct SimpleButton: View {
    @State var simpleButtonText: String
    @State var buttonTextColor: Color
    @State var buttonBackgroundColor: Color
    @State var verticalPadding: CGFloat
    @State var horizontalPadding: CGFloat
    @State var buttonCornerRadius: CGFloat
    @State var action: () -> Void
    @State var textFont: Font
    
    var body: some View {
        Button {
            action()
        } label: {
           
            Text(simpleButtonText.localized)
               
                .font(textFont)
                .foregroundColor(buttonTextColor)
                .background(buttonBackgroundColor)
                .cornerRadius(buttonCornerRadius)
            
            
            Spacer()
        }
    }
}


#Preview {
    SimpleButton(simpleButtonText: "sign up", buttonTextColor: .white, buttonBackgroundColor: .black, verticalPadding: 10, horizontalPadding: 100, buttonCornerRadius: 15, action: {}, textFont: .body)
}


