//
//  OrderedPartCard.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 19/07/2025.
//
import SwiftUI


struct OrderedPartCard: View {
    let part: Part
    let id: Int
    var onPictureTap: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            partRow(label: "part name".localized, value: part.name)
            partRow(label: "part number".localized, value: part.number)
            partRow(label: "part type".localized, value: part.type)
            partRow(label: "parts count".localized, value: "\(part.count)")

            // الملاحظات
            if let notes = part.notes?.trimmingCharacters(in: .whitespacesAndNewlines),
               notes.isEmpty == false {
                Divider()

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("part notes".localized)
                            .foregroundStyle(Color.SecondaryColor)
                            .font(addFont(fontType: .Medium, size: 15))
                        Spacer()
                    }
                    HStack {
                        Text(notes)
                            .foregroundStyle(Color.CBlack)
                            .font(addFont(fontType: .Regular, size: 15))
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
            }

            Divider()

            Button {
                onPictureTap()
            } label: {
                Text("show pictures".localized)
                    .font(addFont(fontType: .bold, size: 15))
                    .foregroundStyle(Color.CWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(
                        Color.MainColor
                            .cornerRadius(20)
                    )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CWhite)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)

    }

    private func partRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(Color.SecondaryColor)
                .font(addFont(fontType: .Medium, size: 15))
            Spacer()
            Text(value)
                .foregroundStyle(Color.CBlack)
                .font(addFont(fontType: .bold, size: 15))
        }
    }
}

struct Part: Identifiable {
    let id = UUID()
    let name: String
    let number: String
    let count: String
    let type: String
    var notes: String? = nil
}
