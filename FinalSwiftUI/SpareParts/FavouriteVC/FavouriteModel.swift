//
//  FavouriteModel.swift
//  MyAuctions
//
//  Created by مهاب موافي on 6/26/25.
//

import Foundation
import SwiftUI
import Foundation
struct FavouriteModel: Codable {
    let data: [Trader]?
    let links: Links?
    let meta: Meta?
}

// MARK: - Meta
struct Meta: Codable {
    let currentPage: Int?
    let from: Int?
    let lastPage: Int?
    let links: [Link]?
    let path: String?
    let perPage: Int?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case links, path
        case perPage = "per_page"
        case to, total
    }
}

// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String?
    let page: Int?
    let active: Bool?
}

//struct FavouriteModel: Codable {
//    let currentPage: Int?
//    let data: [Datum]?
//    let firstPageURL: String?
//    let from, lastPage: Int?
//    let lastPageURL: String?
//    let links: [Link]?
//    let nextPageURL: String?
//    let path: String?
//    let perPage: Int?
//    let prevPageURL: String?
//    let to, total: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case currentPage = "current_page"
//        case data
//        case firstPageURL = "first_page_url"
//        case from
//        case lastPage = "last_page"
//        case lastPageURL = "last_page_url"
//        case links
//        case nextPageURL = "next_page_url"
//        case path
//        case perPage = "per_page"
//        case prevPageURL = "prev_page_url"
//        case to, total
//    }
//}
//
//// MARK: - Datum
//struct Datum: Codable, VendorDisplayable {
//    let id: Int?
//    let name, phone: String?
//    let phoneVerifiedAt: String?
//    let email: String?
//    let emailVerifiedAt: String?
//    let otpResendCount: Int?
//    let lastOtpSentAt: String?
//    let cityID: Int?
//    let areaID: Int?
//    let countryID: Int?
//    let bio, tradeNameAr, tradeNameEn, commercialRegNum: String?
//    let bankName, accountHolderName, accountNumber, iban: String?
//    let isAcceptingRequests: Int?
//    let latitude, longitude, status, createdAt: String?
//    let updatedAt: String?
//    let city: City?
//    let media: [Media]?
//    let pivot: Pivot?
//    var isFavourite: Bool?
//    var logo: String? {
//        return media?[0].originalURL ?? ""
//    }
//    var rating: Double?
//    var cityName: String? {
//        return nil
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, phone
//        case phoneVerifiedAt = "phone_verified_at"
//        case email
//        case emailVerifiedAt = "email_verified_at"
//        case otpResendCount = "otp_resend_count"
//        case lastOtpSentAt = "last_otp_sent_at"
//        case cityID = "city_id"
//        case areaID = "area_id"
//        case countryID = "country_id"
//        case bio
//        case tradeNameAr = "trade_name_ar"
//        case tradeNameEn = "trade_name_en"
//        case commercialRegNum = "commercial_reg_num"
//        case bankName = "bank_name"
//        case accountHolderName = "account_holder_name"
//        case accountNumber = "account_number"
//        case iban
//        case isAcceptingRequests = "is_accepting_requests"
//        case latitude, longitude, status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case city, media, pivot
//    }
//}
//
//// MARK: - Link
//struct Link: Codable {
//    let url: String?
//    let label: String?
//    let page: Int?
//    let active: Bool?
//}
//
//// MARK: - Link
//struct LinkFavourites: Codable {
//    let url: String?
//    let label: String?
//    let page: Int?
//    let active: Bool?
//}
//
//// MARK: - Listing
struct Listing: Codable {
    let id: Int?
    let title: String?
    let city: String?
    let publicationDate: String?
    let mainImage: String?
    let price: String?
    let status : String?
    let type : String?
    var isFavourite: Bool = false
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case city
        case publicationDate = "publication_date"
        case mainImage = "main_image"
        case status = "status"
        case price
        case type = "type"
    }
}
//
// MARK: - Pagination
struct Pagination: Codable {
    let total: Int?
    let perPage: Int?
    let currentPage: Int?
    let lastPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
    }
}
//
//// MARK: - Mock Data for Datum
//
////// Create mock data using JSON decoding approach
////func createMockData() -> [Datum] {
////
////    // Mock data for City
////    let cityJSON = """
////    {
////        "id": 1,
////        "country_id": 1,
////        "name": "Riyadh",
////        "created_at": "2024-01-15T10:30:00Z",
////        "updated_at": "2024-01-15T10:30:00Z"
////    }
////    """
////
////    // Mock data for Media
////    let mediaJSON = """
////    [{
////        "id": 1,
////        "model_type": "App\\\\Models\\\\Vendor",
////        "model_id": 1,
////        "uuid": "550e8400-e29b-41d4-a716-446655440000",
////        "collection_name": "profile_images",
////        "name": "vendor_profile",
////        "file_name": "vendor_profile.jpg",
////        "mime_type": "image/jpeg",
////        "disk": "public",
////        "conversions_disk": "public",
////        "size": 2048576,
////        "manipulations": [],
////        "custom_properties": [],
////        "generated_conversions": [],
////        "responsive_images": [],
////        "order_column": 1,
////        "created_at": "2024-01-15T10:30:00Z",
////        "updated_at": "2024-01-15T10:30:00Z",
////        "original_url": "https://example.com/images/vendor_profile.jpg",
////        "preview_url": "https://example.com/images/preview/vendor_profile.jpg"
////    }]
////    """
////
////    // Mock data for Pivot
////    let pivotJSON = """
////    {
////        "model_type": "App\\\\Models\\\\User",
////        "model_id": 1,
////        "role_id": 2
////    }
////    """
////
////    // Main Datum JSON
////    let datum1JSON = """
////    {
////        "id": 1,
////        "name": "Mohammed Ahmed",
////        "phone": "+966501234567",
////        "phone_verified_at": "2024-01-15T10:30:00Z",
////        "email": "mohammed.ahmed@example.com",
////        "email_verified_at": "2024-01-15T10:30:00Z",
////        "otp_resend_count": 2,
////        "last_otp_sent_at": "2024-01-15T09:15:00Z",
////        "city_id": 1,
////        "area_id": 15,
////        "country_id": 1,
////        "bio": "Experienced vendor with 5+ years in the market",
////        "trade_name_ar": "التجارة المثالية",
////        "trade_name_en": "Ideal Trading",
////        "commercial_reg_num": "CR123456789",
////        "bank_name": "Al Rajhi Bank",
////        "account_holder_name": "Mohammed Ahmed",
////        "account_number": "SA0380000000608010167519",
////        "iban": "SA0380000000608010167519",
////        "is_accepting_requests": 1,
////        "latitude": "24.7136",
////        "longitude": "46.6753",
////        "status": "active",
////        "created_at": "2024-01-10T08:00:00Z",
////        "updated_at": "2024-01-15T14:20:00Z",
////        "isFavourite": true,
////        "rating": 4
////    }
////    """
////
////    let datum2JSON = """
////    {
////        "id": 2,
////        "name": "Sarah Johnson",
////        "phone": "+966502345678",
////        "phone_verified_at": "2024-01-14T11:20:00Z",
////        "email": "sarah.johnson@example.com",
////        "email_verified_at": "2024-01-14T11:20:00Z",
////        "otp_resend_count": 1,
////        "last_otp_sent_at": "2024-01-14T10:45:00Z",
////        "city_id": 2,
////        "area_id": 22,
////        "country_id": 1,
////        "bio": "Professional service provider",
////        "trade_name_ar": "الخدمات المتميزة",
////        "trade_name_en": "Premium Services",
////        "commercial_reg_num": "CR987654321",
////        "bank_name": "Saudi National Bank",
////        "account_holder_name": "Sarah Johnson",
////        "account_number": "SA0380000000608010167520",
////        "iban": "SA0380000000608010167520",
////        "is_accepting_requests": 1,
////        "latitude": "21.4858",
////        "longitude": "39.1925",
////        "status": "active",
////        "created_at": "2024-01-12T09:15:00Z",
////        "updated_at": "2024-01-15T16:30:00Z",
////        "isFavourite": false,
////        "rating": 4
////    }
////    """
////
////    let datum3JSON = """
////    {
////        "id": 3,
////        "name": "Ahmed Hassan",
////        "phone": "+966503456789",
////        "email": "ahmed.hassan@example.com",
////        "email_verified_at": "2024-01-13T14:10:00Z",
////        "otp_resend_count": 3,
////        "last_otp_sent_at": "2024-01-15T08:30:00Z",
////        "city_id": 1,
////        "area_id": 18,
////        "country_id": 1,
////        "bio": "New vendor offering innovative solutions",
////        "trade_name_ar": "التجارة الحديثة",
////        "trade_name_en": "Modern Trade",
////        "commercial_reg_num": "CR456789123",
////        "bank_name": "Alinma Bank",
////        "account_holder_name": "Ahmed Hassan",
////        "account_number": "SA0380000000608010167521",
////        "iban": "SA0380000000608010167521",
////        "is_accepting_requests": 0,
////        "latitude": "24.7136",
////        "longitude": "46.6753",
////        "status": "pending",
////        "created_at": "2024-01-13T14:10:00Z",
////        "updated_at": "2024-01-15T08:30:00Z",
////        "isFavourite": null,
////        "rating": 0
////    }
////    """
////
////    do {
////        let decoder = JSONDecoder()
////
////        // Decode city
////        let cityData = cityJSON.data(using: .utf8)!
////        let city = try decoder.decode(String.self, from: cityData)
////
////        // Decode other objects
////        let media = try decoder.decode([Media].self, from: mediaJSON.data(using: .utf8)!)
////        let pivot = try decoder.decode(Pivot.self, from: pivotJSON.data(using: .utf8)!)
////
////        // Decode datum objects
////        var datum1 = try decoder.decode(Datum.self, from: datum1JSON.data(using: .utf8)!)
////        var datum2 = try decoder.decode(Datum.self, from: datum2JSON.data(using: .utf8)!)
////        var datum3 = try decoder.decode(Datum.self, from: datum3JSON.data(using: .utf8)!)
////
////        // ✅ Manually set the nested City object
////        datum1.city = city
////        datum2.city = city
////        datum3.city = city
////
////        // ✅ (optional) assign media or pivot if needed
////        datum1.media = media
////        datum1.pivot = pivot
////
////        return [datum1, datum2, datum3]
////
////    } catch {
////        print("Error creating mock data: \(error)")
////        return []
////    }
////
////}
