//
//  ئعسفخو]رأخشقيهرلءهثص.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 28/04/2025.
//

import SwiftUI

struct CustomeOnBoardingView: View {
 
     @Binding var title_label: String
    @Binding var image_title: String
    @Binding var is_first_page: Bool
     
    var body: some View {
        
            VStack {

                VStack (spacing: 84) {
                    VStack(spacing:24) {
                        Image(image_title)
                        Text(title_label).font(addFont(fontType: .Regular, size: 12)).multilineTextAlignment(.center).padding()
                    }
                   
            
                    HStack {
                        SkipButton(title: "Next") {
                            print("Next")
                        }
                        Spacer()
                        if !is_first_page {
                            SkipButton(title: "Previos") {
                                print("Previos")
                            }
                        }
                       
                    }.padding()
                }
               
               
            }
               

    }
}

struct TopRoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//#Preview {
//    CustomeOnBoardingView(title_label:  " بوابتك المثالية لعالم تأجير المعدات", desLbl: "منصة شاملة تجمع بين سهولة الاستخدام وتعدد الخيارات. أجّر أو استأجر بكبسة زر")
//}
