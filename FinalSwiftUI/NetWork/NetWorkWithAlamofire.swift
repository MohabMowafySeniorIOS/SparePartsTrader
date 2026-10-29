//
//  NetWorkWithAlamofire.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 12/01/2025.
//

import Foundation
import Alamofire
import Combine
var counter = 1

final class SessionEvents {
    static let shared = SessionEvents()
    let unauthorized = PassthroughSubject<Void, Never>()
    private init() {}
}

struct APIClient {
    static let shared = APIClient()
    private init() {}
    func performRequestWithAlamofire<T: Decodable>(
        urlString: String,
        method: HTTPMethodType,
        parameters: [String: Any]?,
        
        completion: @escaping (T? ,String?)->Void) {
            var headers : HTTPHeaders?
            let lang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
            headers = [
                "Accept-Language": lang,
                "Content-Type": "application/json",
                "Accept": "application/json",
                "user-type": userType
            ]
            
            if AuthService.userData?.token != "" && AuthService.userData?.token  != nil {
                headers?["Authorization"] = "Bearer \(AuthService.userData?.token ?? "")"
            }
          
            AF.request(
                urlString,
                method: HTTPMethod(rawValue: method.rawValue),
                parameters: parameters,
                encoding: JSONEncoding.default, // Use `URLEncoding.default` for GET queries
                headers: headers
            )
            .validate(statusCode: 200...300)
            .responseData { response in
                
               
                switch response.result {
                case .success(let data):
                    
                    guard let data = response.data else {
                        return
                    }
                    do {
                        
                        
                        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                           let jsonDict = jsonObject as? [String: Any] {
                            if ((jsonDict["status"] as? String) == "fail") || ((jsonDict["status"] as? Bool) == false){
                                completion(nil , jsonDict["message"] as? String)
                            }
                        } else {
                        }
                        let Posts = try JSONDecoder().decode(T.self, from: data)
                        completion(Posts, nil)
                    }catch let error {
                        completion(nil , "\(error)")
                        
                    }
                    
                case .failure(let error):
                    completion(nil, handleAlamofireError(response: response, error: error))
                }
            }
        }
    
    func uploadMultipartWithAlamofire<T: Decodable>(
        urlString: String,
        images: UIImage = UIImage(),
        imageFieldName: String = "images[]", // Use "file" if it's a single image field
        additional_images: [UIImage] = [],
        additional_imageFieldName: String = "additional_images[]", // Use "file" if it's a single image field
        profile_image : UIImage? = nil,
        file : UIImage? = nil,
        
        parameters: [String: Any] = [:],
        methodType: HTTPMethod = .post,
        completion: @escaping (T?, String?) -> Void
    ) {
        let lang = Language.english.rawValue
        var headers: HTTPHeaders = [
            "Accept-Language": lang,
            "Accept": "application/json"
        ]
        
        if let token = AuthService.userData?.token, !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
            headers["user-type"] = userType
        }
        

        AF.upload(
            multipartFormData: { multipartFormData in
                // Append images
            
//                if let imageData = UIImage(named: "image")?.jpegData(compressionQuality: 0.8) {
//                        
//                        multipartFormData.append(imageData, withName: "images[]", fileName: "images.jpg", mimeType: "images/jpeg")
//                    }
               
                for (index, image) in additional_images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        let name = additional_imageFieldName.contains("[]") ? imageFieldName : "\(imageFieldName)[\(index)]"
                        multipartFormData.append(imageData, withName: name, fileName: "image\(index).jpg", mimeType: "image/jpeg")
                    }
                }
                
                if let imageData = profile_image?.jpegData(compressionQuality: 0.8) {
                    let name = "profile_image"
                    multipartFormData.append(imageData, withName: name, fileName: "image.jpg", mimeType: "image/jpeg")
                }
                
                if let imageData = file?.jpegData(compressionQuality: 0.8) {
                    let name = "file"
                    multipartFormData.append(imageData, withName: name, fileName: "image.jpg", mimeType: "image/jpeg")
                }

                // Append other form parameters
                for (key, value) in parameters {
                    let stringValue = "\(value)"
                    if let data = stringValue.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: urlString,
            method: methodType,
            headers: headers
        )
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                       let jsonDict = jsonObject as? [String: Any],
                       ((jsonDict["status"] as? String) == "fail" || (jsonDict["status"] as? Bool) == false) {
                        completion(nil, jsonDict["message"] as? String)
                        return
                    }
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(decoded, nil)
                } catch {
                    completion(nil, "\(error)")
                }
            case .failure(let error):
                completion(nil, handleAlamofireError(response: response, error: error))
            }
        }
    }

    
    
    func handleAlamofireError(response: AFDataResponse<Data>, error: AFError) -> String {
        var err = ""
        if let responseCode = response.response?.statusCode {
            err = "User Not Authenticated"
            if let responseCode = response.response?.statusCode, responseCode == 401 {
                // restart app to login screen
                AuthService.userData = nil
                DispatchQueue.main.async {
                       SessionEvents.shared.unauthorized.send()
                   }
            }
        }
        
        
        if let data = response.data  {
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
           if let jsonDict = jsonObject as? [String: Any] {
               if ((jsonDict["message"] as? String)?.count ?? 0) > 0 {
                   err = (jsonDict["message"] as? String)!
                   return err
               }
            }
        }

      
        switch error {
        case .sessionTaskFailed(let sessionError):
            err = "Session Task Failed: \(sessionError.localizedDescription)"
        case .responseValidationFailed(let reason):
            err = "Validation Error: \(reason)"
        case .responseSerializationFailed(let reason):
            err = "Serialization Error: \(reason)"
        default:
            
            err = "Other Error: \(error.localizedDescription)"
        }
        return err
    }
}
