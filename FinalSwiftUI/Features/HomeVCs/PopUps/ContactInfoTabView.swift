import SwiftUI

struct ContactInfoTabView: View {
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack (spacing:20){
            ZStack {
                Text("contact_us".localized)
                    .font(addFont(fontType: .bold, size: 16))

                HStack {
                    Image(systemName: "xmark")
                        .font(.system(size: 25))
                        .onTapGesture {
                            dismiss()
                        }
                    Spacer()
                }
            }
            .padding()

            HStack{
                Text("966501198")
                
                Image(systemName: "phone.fill")
                    .foregroundStyle(Color.MainColor.opacity(0.7))
                    .font(.system(size: 25))
            }

            HStack{
                Text("moaza134" + "@gmail.com")
                    .foregroundStyle(Color.CBlack)
                
                Image(systemName: "envelope.fill")
                    .foregroundStyle(Color.MainColor.opacity(0.7))
                    .font(.system(size: 25))
            }
            Button {
                
            } label: {
                HStack{
                    Spacer()
                    Text("contact".localized)
                        .foregroundStyle(Color.CWhite)
                    
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(Color.CWhite)
                        .font(.system(size: 25))
                    Spacer()
                }
                .padding(.vertical,10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.MainColor)
                )
                .padding(.horizontal,50)
            }

        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContactInfoTabView()
}
