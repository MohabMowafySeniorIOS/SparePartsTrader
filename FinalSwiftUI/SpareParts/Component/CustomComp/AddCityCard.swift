//
//  AddCityCard.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 16/07/2025.
//

import SwiftUI
struct AddCityCard: View {
    var model: CountryAndCitiesModel
    var delete: ()->Void
    var body: some View {
        VStack(spacing:10){
            VStack(alignment:.leading){
                HStack(spacing:50){
                    VStack(alignment:.leading,spacing:10){
                        Image(systemName: "house")
                            .foregroundStyle(Color.MainColor)
                        
                        
                        Image(systemName: "house")
                            .foregroundStyle(Color.MainColor)
                    }
                    VStack(alignment:.leading,spacing:10){
                        Text(model.country?.name ?? "")
                            .foregroundStyle(Color.MainColor)
                        
               
                        Text(getCityName(cities: model.cities))
                            .foregroundStyle(Color.MainColor)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
               
              
            }
            
            SimpleSpareButton(buttonTitle: "delete", action: {
                delete()
            }, widthValue: 150, heightValue: 30)
            
        }
        .padding(10)
        .frame(width: 230)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle())
                .fill(Color.MainColor)
        }
        .padding(1)
    }
    
    func getCityName(cities: [CityData]?) -> String{
        var cityName = ""
        if let cities = model.cities {
             cityName = cities.map { ($0.name ?? "") }.joined(separator: ", ")
            
        }
        
        return cityName
    }
}
