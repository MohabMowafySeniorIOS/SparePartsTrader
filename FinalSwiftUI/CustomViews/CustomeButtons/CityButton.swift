//
//  CityButton.swift
//  MyAuctions
//
//  Created by Mohab on 06/07/2025.
//
import SwiftUI

struct GenericDropdownButton<T: Hashable>: View {

    let title: String
    @Binding var selectedItem: T?
    let items: [T]
    let displayText: (T) -> String
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title.localized)
                    .font(.custom(AppFont.Medium.rawValue, size: 16))
                Spacer()
            }

            HStack {
                Text(selectedItem == nil ? "" : displayText(selectedItem!))
                    .font(.custom(AppFont.Medium.rawValue, size: 16))
                    .foregroundStyle(Color.CBlack)

                Spacer()

                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .frame(height: 48)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.CWhite)
            )
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle())
                    .foregroundStyle(isExpanded ? Color.MainColor : Color.TextBorderColor)
            }
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
            .contentShape(Rectangle())
        }
    }
}

struct GenericDropdownSheet<T: Hashable>: View {

    @Binding var selectedItem: T?
    @Binding var isPresented: Bool
    let items: [T]
    let displayText: (T) -> String

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(items, id: \.self) { item in
                    Button {
                        selectedItem = item
                        isPresented = false
                    } label: {
                        HStack {
                            Text(displayText(item))
                                .padding(.horizontal)

                            Spacer()

                            if item == selectedItem {
                                Image(systemName: "checkmark")
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 14)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    Divider()
                        .padding(.leading)
                }
            }
            .padding(.top, 8)
        }
        .padding(.vertical, 12)

        // detents iOS16+
        .modifier(DetentsIfAvailable(height: CGFloat(min(items.count, 8) * 70)))
    }
}

private struct DetentsIfAvailable: ViewModifier {
    let height: CGFloat
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.presentationDetents([.height(height)])
        } else {
            content
        }
    }
}

struct GenericDropdown<T: Hashable & Identifiable>: View {
    let title: String
    @Binding var is_validation_label: Bool
    @Binding var Validation_label: String
    @Binding var selectedItem: T?
    let items: [T]
    let displayText: (T) -> String
   

    @State private var isSheetPresented = false

    var body: some View {
        VStack {
            GenericDropdownButton(
                title: title,
                selectedItem: $selectedItem,
                items: items,
                displayText: displayText,
                isExpanded: $isSheetPresented
            )
            .onTapGesture { isSheetPresented = true }
            .sheet(isPresented: $isSheetPresented) {
                GenericDropdownSheet(
                    selectedItem: $selectedItem,
                    isPresented: $isSheetPresented,
                    items: items,
                    displayText: displayText
                )
            }
            
            if !is_validation_label {
                HStack{
                    Text(Validation_label.localized)
                        .font(addFont(fontType: .bold, size: 12))
                        .foregroundStyle(Color.CRed)
                    
                    Spacer()
                }
            }
        }
       
    }
}
