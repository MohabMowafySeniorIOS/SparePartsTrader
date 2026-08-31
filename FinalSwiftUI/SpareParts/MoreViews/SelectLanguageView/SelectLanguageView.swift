import SwiftUI
enum SelectedLanguage {
    case en, ar
}

struct SelectLanguageView: View {
    
    @State private var selectedLanguage: SelectedLanguage = .en
   
    @EnvironmentObject var languageManager: LanguageManager
   
    
    var body: some View {
        ScrollView{
            VStack(spacing: 50){
                Image("languageLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100,height: 100)
                HStack{
                    Text("choose language")
                        .foregroundStyle(Color.CBlack)
                        .font(.headline)
                    
                    Image(systemName: "globe")
                        .foregroundStyle(Color.MainColor)
                        .font(.system(size: 25))
                }
                .padding(.bottom,10)
                
                HStack {
                    languageSelectionIcon(
                        image: Image("enLang"),
                        isSelected: selectedLanguage == .en
                    )
                    .onTapGesture {
                        selectedLanguage = .en
                    }

                    Spacer()

                    languageSelectionIcon(
                        image: Image("arabLang"),
                        isSelected: selectedLanguage == .ar
                    )
                    .onTapGesture {
                        selectedLanguage = .ar
                    }
                }
                .padding(.horizontal,60)
                .padding(.bottom,50)
                
                ContentButtonView(title: "save".localized) {
                    let languageCode = selectedLanguage == .en ? "en" : "ar"
                    languageManager.currentLanguage = languageCode
                   
                }
                
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
            
    }
}

struct languageSelectionIcon: View {
    let image: Image
    let isSelected: Bool

    var body: some View {
        HStack {
            image

            Circle()
                .stroke(style: StrokeStyle())
                .fill(isSelected ? Color.MainColor : Color.CGray3)
                .frame(width: 15, height: 15)
                .overlay {
                    if isSelected {
                        Circle()
                            .fill(Color.MainColor)
                            .padding(3)
                    }
                }
                .padding(.leading, 10)
        }
        
    }
}

