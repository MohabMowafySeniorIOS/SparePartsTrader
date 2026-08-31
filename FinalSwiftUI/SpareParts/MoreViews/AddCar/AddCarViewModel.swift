//
//  AddCarViewModel.swift
//  MyAuctions
//
//  Created by Mohab Mowafy on 17/07/2025.
//

import Foundation
import Combine
import SwiftUI

class AddCarViewModel: ObservableObject {
   
    
    @Published var getCarCategory  = [categoryModel]()
    @Published var getCarBrand  = [categoryModel]()
    @Published var getCarModel  = [categoryModel]()
    @Published var getCarYears  = [Int]()
    @Published var carCategorySelected: categoryModel? = nil
    @Published var carBrandSelected: categoryModel? = nil
    @Published var carModelSelected: categoryModel? = nil
    @Published var carYearSelected: String? = nil
    @Published var carModel:CarsData?
    
    @Published var state: viewState<CarsData?> = .idle
    
    
    
    @ObservedObject var coordinator: MainCoordinator
    init(coordinator: MainCoordinator,carModel:CarsData?) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.carModel = carModel
        getCategories()
        if let categoryId = self.carModel?.category?.id {
            self.getBrand(categoryId: "\(categoryId)")
        }
        
        if let brancdId = self.carModel?.brand?.id {
            self.getModel(brandId: "\(brancdId)")
        }
        
        if let modelId = self.carModel?.model?.id {
            self.getYears(modelId: "\(modelId)")
        }
        
        
    }
    
    func disMiss(){
        coordinator.path.removeLast()
    }
    
    func getCategories(urlEndPoint:EndPoints = .categories, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[categoryModel]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                
                self.getCarCategory = Model?.data ?? []
             }else {
                 state = .error(err ?? "")
             }
        }
    }
    
    func getBrand(urlEndPoint:EndPoints = .brands,categoryId: String, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)?category_id=\(categoryId)"
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[categoryModel]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.getCarBrand = Model?.data ?? []
             }else {
                 state = .error(err ?? "")
             }
        }
    }
    
    func getModel(urlEndPoint:EndPoints = .Models,brandId: String, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)?brand_id=\(brandId)"
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[categoryModel]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.getCarModel = Model?.data ?? []
             }else {
                 state = .error(err ?? "")
             }
        }
    }
    func getYears(urlEndPoint:EndPoints = .years,modelId: String, methodType: HTTPMethodType = .get) {
        let url = "\(hostName)\(urlEndPoint.rawValue)"
        
       
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: nil) { [weak self] (Model: BaseModel<[Int]>? , err : String? )in
            guard let self = self else { return }
             if Model?.status == "success" {
                self.getCarYears = Model?.data ?? []
             }else {
                 state = .error(err ?? "")
             }
        }
    }
    
    func AddCarData(urlEndPoint:EndPoints = .profile_cars, methodType: HTTPMethodType = .post, paramter: BaseParameters) {
        var url = "\(hostName)\(urlEndPoint.rawValue)"
        var paramter = paramter
        if let carId = carModel?.id  {
            url = "\(hostName)\(urlEndPoint.rawValue)/\(carId)"
            paramter.method = "PUT"
        }
        state = .loading(loading: .progress)
        APIClient.shared.performRequestWithAlamofire(urlString: url, method: methodType, parameters: paramter.toDictionary()) { [weak self] (Model: BaseModel<CarsData>? , err : String? )in
            guard let self = self else { return }
            if Model?.status == "success" {
                self.disMiss()
            }else {
                state = .error(err ?? "")
            }
        }
    }
   
    
    
}

