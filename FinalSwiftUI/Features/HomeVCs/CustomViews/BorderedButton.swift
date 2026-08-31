import SwiftUI

struct BorderedButton: View {
    @State var simpleButtonText: String
    @State var buttonTextColor: Color
    @State var verticalPadding: CGFloat
    @State var horizontalPadding: CGFloat
    @State var buttonCornerRadius: CGFloat
    @State var buttonBorderColor: Color
    @State var action: () -> Void
    @State var textFont: Font
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(simpleButtonText.localized)
                .padding(.horizontal,60)
                .padding(.vertical,verticalPadding - 1)
                .padding(.horizontal,horizontalPadding - 7)
                .font(textFont)
                .foregroundColor(buttonTextColor)
                .background(){
                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                        .stroke(style: StrokeStyle())
                        .fill(buttonBorderColor)
                }
        }
    }
}


#Preview {
    BorderedButton(simpleButtonText: "sign up", buttonTextColor: Color.MainColor, verticalPadding: 15, horizontalPadding: 0, buttonCornerRadius: 15, buttonBorderColor: Color.CRed, action: {}, textFont: .body)
}


