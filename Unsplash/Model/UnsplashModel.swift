//
//  UnsplashModel.swift
//  Unsplash
//
//  Created by alekseienko on 30.10.2022.
//

import Foundation

// MARK: - UnsplashModel
struct UnsplashModel: Codable {
    var total: Int
    var totalPages: Int
    var results: [UnsplasPhoto]
    
    enum CodingKeys: String, CodingKey {
        case total = "total"
        case totalPages = "total_pages"
        case results = "results"
    }
}

// MARK: - Result
struct UnsplasPhoto: Codable {
    var createdAt: String
    var urls: Urls
    var likes: Int
    var user: ResultUser
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case urls = "urls"
        case likes = "likes"
        case user = "user"
    }
}

// MARK: - Urls
struct Urls: Codable {
    var full: String
    var regular: String
    var small: String
    var thumb: String
    var smallS3: String

    enum CodingKeys: String, CodingKey {
        case full = "full"
        case regular = "regular"
        case small = "small"
        case thumb = "thumb"
        case smallS3 = "small_s3"
    }
}

// MARK: - ResultUser
struct ResultUser: Codable {
    var username: String
    var profileImage: FluffyProfileImage

    enum CodingKeys: String, CodingKey {
        case username = "username"
        case profileImage = "profile_image"
    }
}

// MARK: - FluffyProfileImage
struct FluffyProfileImage: Codable {
    var small: String
    
    enum CodingKeys: String, CodingKey {
        case small = "small"
    }
}
