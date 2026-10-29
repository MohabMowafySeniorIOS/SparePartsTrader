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
    let imageUrl: ((T) -> String)?
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title.localized)
                    .font(.custom(AppFont.Medium.rawValue, size: 16))
                Spacer()
            }

            HStack {
                if let selectedItem, let imageUrl, !imageUrl(selectedItem).isEmpty {
                    RemoteImageView(imageUrl: imageUrl(selectedItem))
                        .frame(width: 32, height: 32)
                }
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
    let imageUrl: ((T) -> String)?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(items, id: \.self) { item in
                    Button {
                        selectedItem = item
                        isPresented = false
                    } label: {
                        HStack {
                            if let imageUrl, !imageUrl(item).isEmpty {
                                RemoteImageView(imageUrl: imageUrl(item))
                                    .frame(width: 40, height: 40)
                            }
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
    let imageUrl: ((T) -> String)?
   

    @State private var isSheetPresented = false

    init(title: String,
         is_validation_label: Binding<Bool>,
         Validation_label: Binding<String>,
         selectedItem: Binding<T?>,
         items: [T],
         displayText: @escaping (T) -> String,
         imageUrl: ((T) -> String)? = nil) {
        self.title = title
        self._is_validation_label = is_validation_label
        self._Validation_label = Validation_label
        self._selectedItem = selectedItem
        self.items = items
        self.displayText = displayText
        self.imageUrl = imageUrl
    }

    var body: some View {
        VStack {
            GenericDropdownButton(
                title: title,
                selectedItem: $selectedItem,
                items: items,
                displayText: displayText,
                imageUrl: imageUrl,
                isExpanded: $isSheetPresented
            )
            .onTapGesture { isSheetPresented = true }
            .sheet(isPresented: $isSheetPresented) {
                GenericDropdownSheet(
                    selectedItem: $selectedItem,
                    isPresented: $isSheetPresented,
                    items: items,
                    displayText: displayText,
                    imageUrl: imageUrl
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

struct BrandMultiSelect: View {
    let title: String
    @Binding var selectedItems: [categoryModel]
    let items: [categoryModel]
    @State private var isPresented = false
    @State private var draftSelectedItems: [categoryModel] = []
    @State private var brandSearchText = ""

    private var selectedNames: String {
        selectedItems.compactMap { $0.name }.joined(separator: ", ")
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title.localized).font(.custom(AppFont.Medium.rawValue, size: 16))
                Spacer()
            }
            Button { isPresented = true } label: {
                HStack {
                    if let first = selectedItems.first, let path = first.logo?.path, !path.isEmpty {
                        BrandLogoView(imageUrl: path, size: CGSize(width: 36, height: 36))
                    }
                    Text(selectedNames.isEmpty ? "choose_brand".localized : selectedNames)
                        .font(.custom(AppFont.Medium.rawValue, size: 16))
                        .foregroundStyle(selectedNames.isEmpty ? Color.CGray2 : Color.CBlack)
                        .lineLimit(2)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .frame(minHeight: 48)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.CWhite))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.TextBorderColor))
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $isPresented, onDismiss: {
                draftSelectedItems = selectedItems
                brandSearchText = ""
            }) {
                VStack(spacing: 12) {
                    Text(title.localized)
                        .font(.custom(AppFont.bold.rawValue, size: 18))

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.MainColor)
                        TextField("search_car_brands".localized, text: $brandSearchText)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        if !brandSearchText.isEmpty {
                            Button {
                                brandSearchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.CGray2)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 48)
                    .background(Color.CWhite, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.TextBorderColor))
                    .padding(.horizontal)

                    let query = brandSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
                    let filteredItems = query.isEmpty ? items : items.filter {
                        ($0.name ?? "").range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
                    }

                    if filteredItems.isEmpty {
                        Text(query.isEmpty ? "no_car_brands_available".localized : "no_search_results".localized)
                            .foregroundStyle(Color.CGray2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(filteredItems, id: \.id) { item in
                                    Button { toggle(item) } label: {
                                        HStack(spacing: 12) {
                                            if let path = item.logo?.path, !path.isEmpty {
                                                BrandLogoView(imageUrl: path, size: CGSize(width: 36, height: 36))
                                            }
                                            Text(item.name ?? "")
                                            Spacer()
                                            Image(systemName: draftSelectedItems.contains(where: { $0.id == item.id }) ? "checkmark.square.fill" : "square")
                                                .font(.system(size: 24))
                                                .foregroundStyle(draftSelectedItems.contains(where: { $0.id == item.id }) ? Color.MainColor : Color.CGray2)
                                        }
                                        .padding(.horizontal).padding(.vertical, 12)
                                    }
                                    .buttonStyle(.plain)
                                    Divider()
                                }
                            }
                        }
                    }

                    ContentButtonView(title: "confirm".localized) {
                        selectedItems = draftSelectedItems
                        isPresented = false
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                .padding(.top)
                .onAppear { draftSelectedItems = selectedItems }
                .modifier(DetentsIfAvailable(height: CGFloat(min(max(items.count, 1), 6) * 66 + 190)))
            }
        }
    }

    private func toggle(_ item: categoryModel) {
        if let index = draftSelectedItems.firstIndex(where: { $0.id == item.id }) {
            draftSelectedItems.remove(at: index)
        } else {
            draftSelectedItems.append(item)
        }
    }
}

/// Keeps logos in the merchant registration brand picker visually consistent
/// without cropping brands whose source images have different aspect ratios.
private struct BrandLogoView: View {
    let imageUrl: String
    let size: CGSize

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width, height: size.height)
            } else if phase.error != nil {
                Image(systemName: "car.side")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.CGray2)
                    .padding(min(size.width, size.height) * 0.2)
                    .frame(width: size.width, height: size.height)
            } else {
                ProgressView()
                    .frame(width: size.width, height: size.height)
            }
        }
        .frame(width: size.width, height: size.height)
    }
}
