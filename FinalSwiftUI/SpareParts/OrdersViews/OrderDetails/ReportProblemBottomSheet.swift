//
//  ReportProblemBottomSheet.swift
//  SpareParts
//
//  Created by Mohamed Elboraey on 11/02/2026.
//

import SwiftUI

struct ReasonItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
}

enum BottomSheetType {
    case reportProblem
    case rate
    case cancel

  
    
    var title: String {
        switch self {
        case .reportProblem:
            return "Report a problem".localized
        case .rate:
            return "Rating".localized
        case .cancel:
            return "Cancel order".localized

        }
    }
    
    var buttonTitle: String {
        switch self {
        case .reportProblem:
            return "Confirm report".localized
        case .rate:
            return "Rate".localized
        case .cancel:
            return "Confirm cancellation".localized
        }
    }
}

struct GenaricOrderBottomSheet: View {
     var reasons: [OrderType]
    @Binding var isPresented: Bool
    @State private var selectedReason: String?
    @State private var description: String = ""
    var orderId: String
    @State private var rating: Int = 0
    @StateObject private var viewModel = GenaricOrderBottomSheetViewModel()
    let type: BottomSheetType
    
    var body: some View {
        ShowViewState(state: viewModel.state) { model in
            ZStack {
                if isPresented {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            dismiss()
                        }
                }
                
                if isPresented {
                    VStack {
                        Spacer()
                        
                        content
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: isPresented)
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    private var content: some View {
        VStack(spacing: 20) {
            
            Text(type.title)
                .font(.headline)
                .padding(.top)
            
            if type != .rate {
                HStack {
                    Spacer()
                    Text("Reason".localized)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 12) {
                    ForEach(reasons, id: \.value) { reason in
                        RadioButton(
                            title: reason.label ?? "",
                            isSelected: selectedReason == reason.value ?? ""
                        ) {
                            selectedReason = reason.value ?? ""
                        }
                    }
                }
            } else {
                StarRatingControl(rating: $rating)
            }
            
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.MainColor, lineWidth: 1)
                    .background(Color.white)
                
                TextEditor(text: $description)
                    .padding(8)
                    .frame(height: 120)
                    .scrollContentBackground(.hidden)
            }
            .frame(height: 120)
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
            
            // Buttons
            if type != .rate {
                HStack(spacing: 16) {
                    
                    Button(action: dismiss) {
                        Text("Cancel".localized)
                            .foregroundColor(Color.MainColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.MainColor, lineWidth: 1)
                            )
                    }
                    
                    Button(action: confirm) {
                        Text(type.buttonTitle.localized)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.MainColor)
                            .cornerRadius(25)
                    }
                }
            } else {
                SimpleSpareButton(
                    buttonTitle: type.buttonTitle.localized,
                    action: {
                        print("Rate tapped")
                        confirm()
                    },
                    widthValue: 300,
                    heightValue: 50
                )
            }
        }
        .padding()
        .background(
            RoundedCorner(radius: 25, corners: [.topLeft, .topRight])
                .fill(Color.white)
        )
    }
    
    private func dismiss() {
        isPresented = false
        selectedReason = nil
        rating = 0
        description = ""
    }
    
    
    private func confirm() {
        switch type {
        case .reportProblem:
            var param: BaseParameters = BaseParameters()
            param.description = description
            param.problem_type = selectedReason ?? ""
            viewModel.report(orderId: orderId, parameters: param)
            viewModel.onSuccess = {
                dismiss()
            }
        case .rate:
            viewModel.rate(orderId: orderId, parameters: .init(rating: String(rating), comment: description))
            viewModel.onSuccess = {
                dismiss()
            }
        case .cancel:
            viewModel.cancel(orderId: orderId, parameters: .init(rating: String(rating), comment: description))
            viewModel.onSuccess = {
                dismiss()
            }
        }
    }
}
//#Preview {
//    ReportProblemBottomSheet()
//}

struct RadioButton: View {
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .stroke(Color.black, lineWidth: 2)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.MainColor : Color.clear)
                    )
                    .frame(width: 20, height: 20)
                
                Spacer()
                
                Text(title)
                    .foregroundColor(.black)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.MainColor, lineWidth: 1)
            )
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 25.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct StarRatingControl: View {
    @Binding var rating: Int
        var maxRating: Int = 5
        var starSize: CGFloat = 30
        var spacing: CGFloat = 8
        var activeColor: Color = .yellow
        var inactiveColor: Color = .gray
        
        var body: some View {
            HStack(spacing: spacing) {
                ForEach(1...maxRating, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: starSize, height: starSize)
                        .foregroundColor(index <= rating ? activeColor : inactiveColor)
                        .onTapGesture {
                            rating = index
                        }
                }
            }
        }
    }
