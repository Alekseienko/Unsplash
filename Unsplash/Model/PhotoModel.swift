//
//  PhotoModel.swift
//  Unsplash
//
//  Created by alekseienko on 02.11.2022.
//
import Foundation
import RealmSwift

// MARK: - PhotoObject
final class PhotoObject: Object {
    @objc dynamic var username: String = ""
    @objc dynamic var usernameImage: String = ""
    @objc dynamic var photoImage: String = ""
}

